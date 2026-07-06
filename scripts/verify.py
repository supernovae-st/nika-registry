#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2026 SuperNovae Studio <contact@supernovae.studio>
#
# verify.py — the registry's whole trust model, executable.
#
# Every entry is RE-PROVEN, never trusted: the pinned bytes are fetched
# from the source repo at the pinned rev, hashed, and run through the
# conformance oracle. The [cert] block in an entry is informative; THIS
# is the proof. A consumer can run the same script offline against a
# mirror — trust lives in the artifact, not in this repo.
#
# Structural rules enforced here (each maps to a documented registry death):
#   R1 immutability     an entry file, once merged, never changes bytes
#                       (left-pad / rug-pull class · checked in CI diff mode)
#   R2 digest pinning   source.rev is a full 40-hex commit · sha256 is full
#                       64-hex · no tags, no branches (tj-actions class)
#   R3 hash match       fetched bytes MUST hash to integrity.sha256
#                       (manifest-confusion class · the entry cannot lie)
#   R4 oracle pass      the artifact re-passes conformance at verify time
#                       (conformance-as-trust · the Nika-only moat)
#   R5 no secrets       key-shaped strings refuse the gate (n8n template
#                       class — the dominant shared-workflow leak)
#   R6 namespace = dir  registry/<type>s/<publisher>/ MUST equal the
#                       source repo owner (dependency-confusion class)
#   R7 license floor    OSI-allowlisted license, declared
#
# Usage:
#   python3 scripts/verify.py --all                 # every entry (nightly)
#   python3 scripts/verify.py entry.toml [...]      # specific entries (PR)
# Env:
#   NIKA_SPEC_DIR   path to a nika-spec checkout (the oracle) — REQUIRED
#   OFFLINE_ROOT    resolve sources from local checkouts instead of the
#                   network: <OFFLINE_ROOT>/<repo-name> (mirrors · air-gap)

import hashlib
import os
import pathlib
import re
import subprocess
import sys
import tomllib
import urllib.request

ROOT = pathlib.Path(__file__).resolve().parent.parent
LICENSES = {"Apache-2.0", "MIT", "BSD-2-Clause", "BSD-3-Clause", "ISC", "MPL-2.0", "AGPL-3.0-or-later", "CC0-1.0"}
TYPES = {"workflow", "pack", "skill", "agent", "template", "policy", "bench"}
# Closed field sets — an unknown key is refused (the local manifest-confusion
# guard: nothing rides an entry that the gate does not understand).
FIELDS = {"schema", "type", "name", "publisher", "version", "description", "license", "spec", "source", "integrity", "cert", "signature"}
SOURCE_FIELDS = {"repo", "rev", "path"}
NAME_RE = re.compile(r"[a-z0-9][a-z0-9-]{0,63}")
OWNER_RE = re.compile(r"[A-Za-z0-9][A-Za-z0-9-]{0,38}")
REPO_RE = re.compile(r"[A-Za-z0-9][A-Za-z0-9-]{0,38}/[A-Za-z0-9._-]{1,100}")
VERSION_RE = re.compile(r"\d+\.\d+\.\d+(?:-[A-Za-z0-9.-]+)?")
# Workflows are KB of text — a multi-MB "workflow" is an attack or a mistake.
MAX_ARTIFACT_BYTES = 1_000_000
SECRET_PATTERNS = [
    re.compile(p) for p in (
        r"sk-[A-Za-z0-9]{20,}",            # OpenAI-style
        r"sk-ant-[A-Za-z0-9-]{20,}",       # Anthropic
        r"AKIA[0-9A-Z]{16}",               # AWS access key
        r"ghp_[A-Za-z0-9]{36}",            # GitHub PAT
        r"github_pat_[A-Za-z0-9_]{22,}",   # GitHub fine-grained
        r"xox[baprs]-[A-Za-z0-9-]{10,}",   # Slack
        r"-----BEGIN [A-Z ]*PRIVATE KEY",  # PEM
        r"eyJhbGciOi[A-Za-z0-9_-]{20,}",   # JWT
    )
]
FAILS = []


def fail(entry, rule, detail):
    FAILS.append((entry, rule, detail))
    print(f"✗ {rule}  {entry}  {detail}")


def fetch_source(repo, rev, path):
    offline = os.environ.get("OFFLINE_ROOT")
    if offline:
        local = pathlib.Path(offline) / repo.split("/")[1]
        out = subprocess.run(["git", "-C", str(local), "show", f"{rev}:{path}"],
                             capture_output=True)
        if out.returncode != 0:
            raise FileNotFoundError(out.stderr.decode()[:120])
        return out.stdout
    url = f"https://raw.githubusercontent.com/{repo}/{rev}/{path}"
    req = urllib.request.Request(url, headers={"User-Agent": "nika-registry-verify"})
    with urllib.request.urlopen(req, timeout=30) as r:
        body = r.read(MAX_ARTIFACT_BYTES + 1)
    if len(body) > MAX_ARTIFACT_BYTES:
        raise ValueError(f"artifact exceeds {MAX_ARTIFACT_BYTES} bytes (workflows are KB of text)")
    return body


def verify(entry_path: pathlib.Path) -> None:
    rel = entry_path.relative_to(ROOT)
    if len(rel.parts) != 5 or rel.parts[0] != "registry":
        return fail(rel, "schema", "entry must live at registry/<type>s/<publisher>/<name>/<version>.toml")
    e = tomllib.loads(entry_path.read_text())

    for field in ("schema", "type", "name", "publisher", "version", "description", "license", "spec", "source", "integrity"):
        if field not in e:
            return fail(rel, "schema", f"missing field `{field}`")
    if unknown := set(e) - FIELDS:
        return fail(rel, "schema", f"unknown field(s) {sorted(unknown)} — the gate refuses what it does not understand")
    if e["schema"] != 1:
        return fail(rel, "schema", f"unsupported schema {e['schema']!r}")
    if e["type"] not in TYPES:
        return fail(rel, "schema", f"unknown type `{e['type']}` (one of {sorted(TYPES)})")
    if not NAME_RE.fullmatch(e["name"]):
        return fail(rel, "schema", "name must be lowercase kebab (≤64 chars)")
    if not OWNER_RE.fullmatch(e["publisher"]):
        return fail(rel, "schema", "publisher must be a GitHub owner name")
    if not VERSION_RE.fullmatch(e["version"]):
        return fail(rel, "schema", "version must be semver (MAJOR.MINOR.PATCH)")
    src, integ = e["source"], e["integrity"]
    if unknown := set(src) - SOURCE_FIELDS:
        return fail(rel, "schema", f"unknown source field(s) {sorted(unknown)}")
    if not REPO_RE.fullmatch(src.get("repo", "")):
        return fail(rel, "R6-namespace", "source.repo must be owner/name")
    path_ = src.get("path", "")
    if path_.startswith("/") or ".." in path_.split("/") or "\\" in path_:
        return fail(rel, "R2-pin", "source.path must be repo-relative with no traversal")
    if e["type"] == "workflow" and not path_.endswith(".nika.yaml"):
        return fail(rel, "schema", "a workflow source must be a .nika.yaml file")

    # R2 · digest pinning — full commit + full sha256, nothing mutable.
    if not re.fullmatch(r"[0-9a-f]{40}", src.get("rev", "")):
        return fail(rel, "R2-pin", "source.rev must be a full 40-hex commit (no tags/branches)")
    if not re.fullmatch(r"[0-9a-f]{64}", integ.get("sha256", "")):
        return fail(rel, "R2-pin", "integrity.sha256 must be full 64-hex")

    # R6 · namespace = source ownership (dependency-confusion firewall).
    publisher_dir, name_dir, version_file = rel.parts[2], rel.parts[3], rel.parts[4]
    if rel.parts[1] != f"{e['type']}s":
        return fail(rel, "schema", f"type `{e['type']}` must live under registry/{e['type']}s/")
    if e["publisher"] != publisher_dir or not src["repo"].startswith(f"{publisher_dir}/"):
        return fail(rel, "R6-namespace", f"publisher `{e['publisher']}` must own dir `{publisher_dir}` AND source repo `{src['repo']}`")
    if e["name"] != name_dir or version_file != f"{e['version']}.toml":
        return fail(rel, "R6-namespace", "entry path must be <publisher>/<name>/<version>.toml")

    # R3 · the pinned bytes hash to the declared digest.
    try:
        body = fetch_source(src["repo"], src["rev"], src["path"])
    except Exception as exc:  # noqa: BLE001 — an unreachable source IS a finding
        return fail(rel, "R3-hash", f"source unreachable: {exc}")
    actual = hashlib.sha256(body).hexdigest()
    if actual != integ["sha256"]:
        return fail(rel, "R3-hash", f"bytes hash to {actual[:12]}…, entry declares {integ['sha256'][:12]}…")

    # R5 · no key-shaped strings in the shared artifact.
    text = body.decode(errors="replace")
    for pat in SECRET_PATTERNS:
        if pat.search(text):
            return fail(rel, "R5-secrets", f"key-shaped string matches {pat.pattern[:24]}…")

    # R7 · license floor.
    if e["license"] not in LICENSES:
        return fail(rel, "R7-license", f"`{e['license']}` not in the allowlist")

    # R4 · the oracle re-proves the artifact (workflows only, v0).
    # The envelope is checked BY the oracle (a heuristic line-scan gave a
    # false positive on a workflow with a long licence banner) — let the
    # proof do the proving.
    if e["type"] == "workflow":
        spec_dir = os.environ.get("NIKA_SPEC_DIR")
        if not spec_dir:
            return fail(rel, "R4-oracle", "NIKA_SPEC_DIR unset (the oracle checkout)")
        tmp = ROOT / ".verify-tmp" / rel.parts[-2]
        tmp.mkdir(parents=True, exist_ok=True)
        wf = tmp / pathlib.Path(src["path"]).name
        wf.write_bytes(body)
        out = subprocess.run(
            [sys.executable, "conformance/runner.py", "validate", str(wf)],
            cwd=spec_dir, capture_output=True, text=True)
        if out.returncode != 0:
            return fail(rel, "R4-oracle", (out.stdout + out.stderr).strip()[-160:])

    print(f"✓ {rel}  ({e['type']} · {e['name']}@{e['version']} · re-proven)")


def main() -> int:
    args = sys.argv[1:]
    if args == ["--all"]:
        entries = sorted(ROOT.glob("registry/**/*.toml"))
    else:
        entries = [pathlib.Path(a).resolve() for a in args]
    if not entries:
        print("no entries to verify")
        return 0
    for p in entries:
        verify(p)
    print(f"\n{len(entries) - len(FAILS)}/{len(entries)} entries re-proven")
    return 1 if FAILS else 0


if __name__ == "__main__":
    sys.exit(main())
