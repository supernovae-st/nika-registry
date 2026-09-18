#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0
"""Live old-suffix ratchet for issue #1684.

Canonical executable Nika program source is lowercase ``*.nika``.
Retired live spellings ``.nika.yaml`` and ``.nika.yml`` must not appear
in tracked pathnames or live teaching text. Project ``nika.yaml`` and
runtime ``.nika/`` are different artifacts and are not this gate.

Exceptions must name path + bounded match + category + reason + owner.
Categories: historical · frozen-evidence · negative-test.
This is not a live compatibility exemption.
"""
from __future__ import annotations

import pathlib
import re
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
FORBIDDEN = re.compile(r"\.nika\.ya?ml")

EXCEPTIONS: list[dict] = [
    {
        "path": "scripts/suffix_ratchet.py",
        "match": r"\.nika\.ya?ml",
        "category": "negative-test",
        "reason": "the ratchet's own forbidden-pattern data",
        "owner": "nika-registry",
    },
    {
        "path": "scripts/test_suffix_ratchet.py",
        "match": r"\.nika\.ya?ml",
        "category": "negative-test",
        "reason": "mutation fixture that must keep the retired spelling to prove detection",
        "owner": "nika-registry",
    },
    {
        "path": "scripts/verify.py",
        "match": r"\.nika\.ya?ml",
        "category": "negative-test",
        "reason": "legacy-suffix admission predicate and its refusal text",
        "owner": "nika-registry",
    },
    {
        "path": "scripts/selftest.py",
        "match": r"\.nika\.ya?ml",
        "category": "negative-test",
        "reason": "asserts legacy suffix is refused except at the frozen pre-cut spec rev",
        "owner": "nika-registry",
    },
    {
        "path_prefix": "registry/",
        "match": r"\.nika\.ya?ml",
        "category": "frozen-evidence",
        "reason": "immutable published 0.1.0 entries pin nika-spec@699ebb08 paths; do not rewrite; mint a new version after SPEC_PIN moves",
        "owner": "scripts/project_pack.py",
    },
    {
        "path": "index.json",
        "match": r"\.nika\.ya?ml",
        "category": "frozen-evidence",
        "reason": "projection of the immutable 0.1.0 source.path fields",
        "owner": "scripts/index.py",
    },
    {
        "path": "estate.yaml",
        "match": r"\.nika\.ya?ml",
        "category": "frozen-evidence",
        "reason": "estate inputs record the pinned spec paths of immutable entries",
        "owner": "scripts/estate.py",
    },
    {
        "path_prefix": "completions/",
        "match": r"\.nika\.ya?ml",
        "category": "frozen-evidence",
        "reason": "clap_complete output from the released engine; regenerate with nika completions <shell> after the engine file-identity commit",
        "owner": "engine clap_complete",
    },
    {
        "path": "README.md",
        "match": r"0\.1\.0\.nika\.yaml",
        "category": "historical",
        "reason": "verbatim 0.118.7 engine transcript of the registry cache basename",
        "owner": "nika-registry README",
    },
    {
        "path": "README.md",
        "match": r"<version>\.nika\.yaml",
        "category": "frozen-evidence",
        "reason": "documents the released engine cache spelling until the engine pin moves",
        "owner": "nika-registry README / engine",
    },
    {
        "path": "README.md",
        "match": r"examples/meeting-actions\.nika\.yaml",
        "category": "historical",
        "reason": "verbatim get.py transcript against immutable 0.1.0 source.path",
        "owner": "nika-registry README",
    },
    {
        "path": "README.md",
        "match": r"meeting-actions\.nika\.yaml",
        "category": "historical",
        "reason": "verbatim get.py write of the 0.1.0 basename",
        "owner": "nika-registry README",
    },
]


def tracked_files() -> list[pathlib.Path]:
    out = subprocess.run(
        ["git", "-C", str(ROOT), "ls-files", "-z"],
        check=True,
        capture_output=True,
    )
    return [ROOT / p.decode() for p in out.stdout.split(b"\0") if p]


def exception_for(rel: str, line: str) -> dict | None:
    for exc in EXCEPTIONS:
        if "path_prefix" in exc:
            if not rel.startswith(exc["path_prefix"]):
                continue
        elif exc.get("path") != rel:
            continue
        if re.search(exc["match"], line):
            return exc
    return None


def scan() -> list[str]:
    findings: list[str] = []
    used: set[tuple[str, str]] = set()
    for path in tracked_files():
        rel = path.relative_to(ROOT).as_posix()
        if FORBIDDEN.search(rel):
            exc = exception_for(rel, rel)
            if exc is None:
                findings.append(f"PATH {rel}: retired suffix in a tracked pathname")
            else:
                used.add((exc.get("path") or exc.get("path_prefix"), exc["match"]))
        try:
            text = path.read_text(encoding="utf-8")
        except (UnicodeDecodeError, IsADirectoryError, OSError):
            continue
        for n, line in enumerate(text.splitlines(), 1):
            if not FORBIDDEN.search(line):
                continue
            exc = exception_for(rel, line)
            if exc is None:
                findings.append(f"{rel}:{n}: {line.strip()[:200]}")
            else:
                used.add((exc.get("path") or exc.get("path_prefix"), exc["match"]))
    declared = {(e.get("path") or e.get("path_prefix"), e["match"]) for e in EXCEPTIONS}
    for path, match in sorted(declared - used):
        findings.append(f"STALE EXCEPTION {path} match={match!r} — no remaining hit")
    return findings


def main() -> int:
    planted = "this-line-must-match .nika.yaml as a scanner self-check"
    if not FORBIDDEN.search(planted):
        print("suffix-ratchet: scanner no longer matches the retired spelling", file=sys.stderr)
        return 1
    findings = scan()
    if findings:
        print("suffix-ratchet: retired .nika.yaml / .nika.yml still live:", file=sys.stderr)
        for item in findings:
            print(f"  {item}", file=sys.stderr)
        return 1
    print("suffix-ratchet: ok — no live .nika.yaml / .nika.yml outside allowlisted exceptions")
    return 0


if __name__ == "__main__":
    sys.exit(main())
