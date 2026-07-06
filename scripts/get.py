#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2026 SuperNovae Studio <contact@supernovae.studio>
#
# get.py — the consume path, automated but never trusted.
#
# One command does the four manual steps of the README, in order and
# refusing to continue on any mismatch:
#
#   1. resolve   the entry file (name → newest version, or name@version)
#   2. fetch     the pinned bytes from the AUTHOR's repo at the pinned rev
#   3. verify    sha256(bytes) == entry digest · advisories consulted
#   4. audit     `nika check` locally when the binary is present
#
# then writes the artifact and prints the cert summary + next steps.
# This is NOT `curl | sh`: you cloned this repo, you can read this file,
# nothing executes — a workflow lands on disk and YOU decide to run it.
#
# Usage:
#   python3 scripts/get.py meeting-actions
#   python3 scripts/get.py supernovae-st/meeting-actions@0.1.0
#   python3 scripts/get.py --list
# Env:
#   NIKA_BIN      the nika binary for the local audit (default: `nika` on PATH)
#   OFFLINE_ROOT  resolve sources from local checkouts (mirrors · air-gap)

import hashlib
import json
import os
import pathlib
import shutil
import subprocess
import sys
import tomllib

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from verify import MAX_ARTIFACT_BYTES, fetch_source  # noqa: E402 — the same bounded fetch

ROOT = pathlib.Path(__file__).resolve().parent.parent


def entries():
    for p in sorted(ROOT.glob("registry/**/*.toml")):
        yield p, tomllib.loads(p.read_text())


def advisories_for(e) -> list:
    hits = []
    for p in sorted(ROOT.glob("advisories/*.toml")):
        a = tomllib.loads(p.read_text())
        if a["affected"].endswith(f"/{e['name']}") and e["version"] in a["versions"]:
            hits.append(a)
    return hits


def resolve(ref: str):
    """`name` · `publisher/name` · either `@version` — newest version wins."""
    ref, _, want_ver = ref.partition("@")
    want_pub, _, want_name = ref.rpartition("/")
    matches = [
        (p, e) for p, e in entries()
        if e["name"] == want_name
        and (not want_pub or e["publisher"] == want_pub)
        and (not want_ver or e["version"] == want_ver)
    ]
    if not matches:
        return None
    return max(matches, key=lambda m: tuple(int(x) for x in m[1]["version"].split("-")[0].split(".")))


def main() -> int:
    args = sys.argv[1:]
    if args == ["--list"] or not args:
        for _, e in entries():
            print(f"{e['publisher']}/{e['name']}@{e['version']}  ·  {e['description']}")
        return 0

    got = resolve(args[0])
    if not got:
        print(f"get.py: no entry matches {args[0]!r} — try --list", file=sys.stderr)
        return 1
    entry_path, e = got
    src = e["source"]
    print(f"→ {e['publisher']}/{e['name']}@{e['version']}")
    print(f"  source  {src['repo']} @ {src['rev'][:12]} · {src['path']}")

    # Advisories FIRST — a yanked version refuses before any bytes move.
    advs = advisories_for(e)
    if advs:
        for a in advs:
            print(f"✗ ADVISORY {a['id']} ({a['severity']}) — {a['summary']}", file=sys.stderr)
            print(f"  action: {a['action']}", file=sys.stderr)
        return 1

    body = fetch_source(src["repo"], src["rev"], src["path"])
    actual = hashlib.sha256(body).hexdigest()
    if actual != e["integrity"]["sha256"]:
        print(f"✗ HASH MISMATCH — fetched {actual[:16]}…, entry pins {e['integrity']['sha256'][:16]}…", file=sys.stderr)
        print("  refusing to write. The source moved or the entry lies — report it.", file=sys.stderr)
        return 1
    print(f"  sha256  {actual[:16]}… ✓ (matches the pinned digest)")

    dest = pathlib.Path.cwd() / pathlib.Path(src["path"]).name
    if dest.exists():
        print(f"✗ {dest.name} already exists here — refusing to overwrite", file=sys.stderr)
        return 1
    dest.write_bytes(body)
    print(f"  wrote   {dest.name} ({len(body)} bytes)")

    cert_path = ROOT / "certs" / e["publisher"] / e["name"] / f"{e['version']}.json"
    if cert_path.is_file():
        c = json.loads(cert_path.read_text())["certificate"]
        cost = "unbounded (set max_tokens)" if c["cost_usd"]["has_unbounded"] else f"≤ ${c['cost_usd']['bounded_total']:.2f}/run"
        execs = "YES ⚠" if "exec: true" in c["permits_boundary"] else "no"
        print(f"  cert    clean={c['clean']} · exec={execs} · llm_calls={c['llm_calls']} · cost {cost}")

    nika = os.environ.get("NIKA_BIN") or shutil.which("nika")
    if nika:
        out = subprocess.run([nika, "check", str(dest)], capture_output=True, text=True)
        verdict = "clean" if out.returncode == 0 else f"findings (exit {out.returncode})"
        print(f"  audit   nika check · {verdict}")
        if out.returncode != 0:
            print(out.stdout.strip()[-400:])
    else:
        print("  audit   nika not on PATH — run `nika check` before `nika run` (always)")

    # The hand-off is CERT-DRIVEN, not generic. The cold e2e walkthrough
    # caught the lie: a fetch-only workflow (llm_calls=0) was told
    # `--model mock/echo # offline preview` — mock mocks INFER, not fetch,
    # and showcase templates ship placeholder vars (example.com) you must
    # point at your real endpoints. Say what THIS artifact needs.
    print(f"\nnext ·  nika check {dest.name}   # your audit, not ours")
    c = json.loads(cert_path.read_text())["certificate"] if cert_path.is_file() else None
    uses_fetch = bool(c) and "nika:fetch" in c.get("permits_boundary", "")
    llm = (c or {}).get("llm_calls") or 0
    if llm and not uses_fetch:
        print(f"        nika run {dest.name} --model mock/echo   # offline preview (mocks the {llm} infer call{'s' if llm > 1 else ''})")
    elif llm and uses_fetch:
        print(f"        nika run {dest.name} --model mock/echo   # mocks infer · fetch still hits the network")
        print(f"        nika inspect {dest.name}   # check vars: — templates ship placeholder endpoints")
    elif uses_fetch:
        print(f"        nika inspect {dest.name}   # zero model calls · set vars: to YOUR endpoints first")
        print(f"        nika run {dest.name} --var <key>=<value>   # then run against real targets")
    else:
        print(f"        nika run {dest.name}   # offline (no model calls · no network)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
