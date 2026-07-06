#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2026 SuperNovae Studio <contact@supernovae.studio>
#
# selftest.py — assertions on the gate's OWN guards, so a security property
# cannot silently regress. Runnable locally with zero network; wired into CI
# before `verify.py --all`. Not a replacement for --all (which re-proves the
# real entries) — this pins the invariants those entries rely on.

import os
import pathlib
import sys
import tempfile

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import verify  # noqa: E402


FAILED = []


def check(name: str, cond: bool) -> None:
    print(f"{'✓' if cond else '✗'} {name}")
    if not cond:
        FAILED.append(name)


# ── R6 · a repo name with a traversal component is rejected before any fetch ──
# `owner/..` matches REPO_RE (dots are legal name chars) but must not pass: the
# offline fetch would build `<OFFLINE_ROOT>/..` and read out of the mirror.
check("repo owner/.. rejected", not verify.repo_traversal_free("alice/.."))
check("repo owner/. rejected", not verify.repo_traversal_free("alice/."))
check("repo owner/ (empty name) rejected", not verify.repo_traversal_free("alice/"))
check("repo owner/name allowed", verify.repo_traversal_free("alice/name"))
check("repo owner/na.me allowed", verify.repo_traversal_free("alice/na.me"))

# ── Defense in depth · the offline resolver refuses to walk out of the root ──
with tempfile.TemporaryDirectory() as d:
    os.environ["OFFLINE_ROOT"] = d
    (pathlib.Path(d) / "name").mkdir()
    for repo in ("alice/..", "alice/."):
        blocked = False
        try:
            verify.fetch_source(repo, "0" * 40, "x")
        except ValueError:
            blocked = True  # the guard fired
        except Exception:
            blocked = False  # any other error means we reached git = escaped
        check(f"offline resolver blocks {repo!r}", blocked)

# ── Advisories target one entry, not every same-named artifact ──────────────
# `endswith("/name")` yanked innocent entries that shared a name across
# publishers/types; the match must be the exact `<type>s/<publisher>/<name>`.
import get  # noqa: E402 — importing does not run its CLI

_target = {"type": "workflow", "publisher": "alice", "name": "meeting-actions"}
_innocent_pub = {"type": "workflow", "publisher": "bob", "name": "meeting-actions"}
_innocent_type = {"type": "skill", "publisher": "bob", "name": "meeting-actions"}
_aff = "workflows/alice/meeting-actions"
check("advisory hits its exact target", get.advisory_affects(_aff, _target))
check("advisory spares same-name other publisher", not get.advisory_affects(_aff, _innocent_pub))
check("advisory spares same-name other type", not get.advisory_affects(_aff, _innocent_type))

if FAILED:
    print(f"\nselftest FAILED: {len(FAILED)} check(s)", file=sys.stderr)
    sys.exit(1)
print("\nselftest: all gate guards hold")
