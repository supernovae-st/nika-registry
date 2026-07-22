#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2026 SuperNovae Studio <contact@supernovae.studio>
#
# orphan_gate.py — every projection cites a live entry (POLICIES.md law 8).
#
# The #21 ghost: certs/supernovae-st/code-review/0.1.0.json + its badge
# outlived their registry entry, invisible to every drift gate, because
# cert.py --check and index.py --check iterate LIVE entries only — an
# orphan projection is never re-proven, forever. This gate walks the
# tree from the other side: it starts at the PROJECTIONS and demands
# each one's source-of-truth still exists.
#
# Three checks, each a named-orphan failure:
#   1. every certs/<publisher>/<name>/<version>.json has a matching
#      registry/*/<publisher>/<name>/<version>.toml
#   2. every badges/<publisher>--<name>.json names an in-index artifact
#      (badges/catalog.json is the aggregate badge — exempt)
#   3. index.json artifact count == live entry TOML count
#
# Check-only by design: there is no --write. An orphan is not drift to
# regenerate over — it is a deletion that skipped its advisory, and the
# fix is a human act (restore the entry, or tombstone it: advisories/).
#
# Usage:
#   python3 scripts/orphan_gate.py [--check]   # exit 1 · orphans named

import json
import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent


def live_entries() -> set:
    """(publisher, name, version) for every entry TOML in the tree."""
    out = set()
    for p in ROOT.glob("registry/*/*/*/*.toml"):
        # registry/<type>s/<publisher>/<name>/<version>.toml
        _, _, publisher, name, fname = p.relative_to(ROOT).parts
        out.add((publisher, name, fname[: -len(".toml")]))
    return out


def main() -> int:
    mode = sys.argv[1] if len(sys.argv) > 1 else "--check"
    if mode != "--check":
        print(f"orphan_gate: unknown mode {mode!r} (--check only — an orphan is fixed by a human, never regenerated over)", file=sys.stderr)
        return 2

    entries = live_entries()
    entry_keys = {(pub, name) for pub, name, _ in entries}
    orphans = []

    # 1 · every cert cites a live entry
    for p in sorted(ROOT.glob("certs/*/*/*.json")):
        _, publisher, name, fname = p.relative_to(ROOT).parts
        if (publisher, name, fname[: -len(".json")]) not in entries:
            orphans.append(f"{p.relative_to(ROOT)} · no registry entry for {publisher}/{name}@{fname[:-len('.json')]}")

    # 2 · every badge names an in-index artifact
    index = json.loads((ROOT / "index.json").read_text())
    indexed = {(a["publisher"], a["name"]) for a in index["artifacts"]}
    for p in sorted(ROOT.glob("badges/*.json")):
        stem = p.stem
        if stem == "catalog":
            continue
        pub, _, name = stem.partition("--")
        if (pub, name) not in indexed:
            orphans.append(f"{p.relative_to(ROOT)} · {pub}/{name} is not in index.json")

    # 3 · the counts agree (index said 26 while the tree held 27 certs — never again)
    if len(index["artifacts"]) != len(entries):
        orphans.append(f"index.json holds {len(index['artifacts'])} artifacts but the tree holds {len(entries)} entry TOMLs")

    # Sanity the other way: an indexed artifact with no entry TOML would mean
    # a hand-edited index — name it too rather than trust the count alone.
    for pub, name in sorted(indexed - entry_keys):
        orphans.append(f"index.json artifact {pub}/{name} · no registry entry in the tree")

    if orphans:
        print(f"✗ orphan gate · {len(orphans)} projection(s) cite no live entry (POLICIES.md law 8):", file=sys.stderr)
        for o in orphans:
            print(f"  ✗ {o}", file=sys.stderr)
        print("fix: restore the entry, or delete the projection AND tombstone the identifier (advisories/)", file=sys.stderr)
        return 1
    print(f"✓ orphan gate · {len(entries)} entries · every cert, badge and index row cites a live entry")
    return 0


if __name__ == "__main__":
    sys.exit(main())
