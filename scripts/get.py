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
from verify import MAX_ARTIFACT_BYTES, fetch_source, is_broad_permits  # noqa: E402 — the same bounded fetch + ⚠ predicate

ROOT = pathlib.Path(__file__).resolve().parent.parent


def entries():
    for p in sorted(ROOT.glob("registry/**/*.toml")):
        yield p, tomllib.loads(p.read_text())


def advisory_affects(affected: str, e) -> bool:
    """An advisory targets an entry iff its `affected` path is EXACTLY this
    entry's `<type>s/<publisher>/<name>` (the registry dir it names) — never
    merely a matching name. `endswith("/name")` cross-matched same-named
    artifacts across publishers AND types, a false yank of innocent entries;
    this mirrors index.py's exact-path match so the two surfaces agree."""
    return affected == f"{e['type']}s/{e['publisher']}/{e['name']}"


def advisories_for(e) -> list:
    hits = []
    for p in sorted(ROOT.glob("advisories/*.toml")):
        a = tomllib.loads(p.read_text())
        if advisory_affects(a["affected"], e) and e["version"] in a["versions"]:
            hits.append(a)
    return hits


class ResolveError(Exception):
    """A ref that does not resolve to exactly one artifact."""


def version_key(v: str):
    """A semver-precedence sort key (SemVer §11): the numeric core compared
    numerically, and a STABLE release ranked above any pre-release of the same
    core (`0.2.0` > `0.2.0-rc1`). The old key stripped the `-rc1` suffix, so a
    pre-release tied its stable and the tie-break picked the pre-release."""
    core, _, pre = v.partition("-")
    nums = tuple(int(x) for x in core.split("."))
    if not pre:
        return (nums, (1,))  # no pre-release outranks every pre-release
    ids = tuple((0, int(p)) if p.isdigit() else (1, p) for p in pre.split("."))
    return (nums, (0, ids))


def resolve(ref: str):
    """`name` · `publisher/name` · either `@version`. Newest version wins by
    semver precedence. An unqualified `name` that spans MORE THAN ONE publisher
    is REFUSED, not silently resolved to the highest-versioned one — otherwise a
    malicious `evil/foo@9.9.9` would shadow a trusted `alice/foo` (dependency
    confusion). Qualify as `<publisher>/name` to disambiguate."""
    orig = ref
    ref, _, want_ver = ref.partition("@")
    want_pub, _, want_name = ref.rpartition("/")
    matches = [
        (p, e) for p, e in entries()
        if e["name"] == want_name
        and (not want_pub or e["publisher"] == want_pub)
        and (not want_ver or e["version"] == want_ver)
    ]
    if not matches:
        raise ResolveError(f"no entry matches {orig!r} — try --list")
    if not want_pub:
        pubs = sorted({e["publisher"] for _, e in matches})
        if len(pubs) > 1:
            raise ResolveError(f"'{want_name}' is published by {pubs} — qualify as "
                               f"<publisher>/{want_name} (an ambiguous name is refused)")
    return max(matches, key=lambda m: version_key(m[1]["version"]))


def main() -> int:
    args = sys.argv[1:]
    if args == ["--list"] or not args:
        for _, e in entries():
            print(f"{e['publisher']}/{e['name']}@{e['version']}  ·  {e['description']}")
        return 0

    try:
        entry_path, e = resolve(args[0])
    except ResolveError as ex:
        print(f"get.py: {ex}", file=sys.stderr)
        return 1
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
        if is_broad_permits(c["permits_boundary"]):
            # "clean" is NOT "safe": a broad grant (exec / any-tool) means the
            # cert proved the effect fits its DECLARED permits, not that the
            # permitted program or tool is safe. Say it out loud, here, before
            # the run hand-off — the one place the human decides.
            print("  ⚠ broad    this workflow declares an unbounded grant (exec / any-tool);")
            print("             clean means it fits its permits, NOT that it is safe — read it.")

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
    for line in handoff_lines(dest.name, c):
        print(f"        {line}")
    return 0


def handoff_lines(name: str, cert) -> list:
    """The cert-driven "how do I run this" suggestion(s) — pure, so the e2e
    contract is a TEST, not a walkthrough. Two lies were caught here before:
    a fetch-only workflow told `mock/echo # offline preview` (mock mocks INFER,
    not fetch), and an llm-only workflow with a REQUIRED var promised a clean
    preview that fails NIKA-VAR-001 without it. Every run command we suggest
    now carries the `--var` flags a run actually needs — read from the cert, so
    it works offline."""
    if cert is None:
        # No cert on file (community entries carry none yet) — never guess what
        # the artifact does; point at the anatomy first.
        return [f"nika inspect {name}   # no cert on file — see the anatomy first",
                f"nika run {name} --model mock/echo   # mocks any infer · fetch/exec still real"]
    uses_fetch = "nika:fetch" in cert.get("permits_boundary", "")
    llm = cert.get("llm_calls") or 0
    reqvars = cert.get("vars_required") or []
    var_flags = "".join(f" --var {v}=<value>" for v in reqvars)
    var_note = (f" · supply required var{'s' if len(reqvars) > 1 else ''} "
                f"{', '.join(reqvars)}") if reqvars else ""
    if llm and not uses_fetch:
        return [f"nika run {name} --model mock/echo{var_flags}   "
                f"# offline preview (mocks the {llm} infer call{'s' if llm > 1 else ''}{var_note})"]
    if llm and uses_fetch:
        return [f"nika run {name} --model mock/echo{var_flags}   "
                f"# mocks infer · fetch still hits the network{var_note}",
                f"nika inspect {name}   # check vars: — templates ship placeholder endpoints"]
    if uses_fetch:
        return [f"nika inspect {name}   # zero model calls · set vars: to YOUR endpoints first",
                f"nika run {name}{var_flags or ' --var <key>=<value>'}   # then run against real targets"]
    return [f"nika run {name}{var_flags}   # offline (no model calls · no network{var_note})"]


if __name__ == "__main__":
    sys.exit(main())
