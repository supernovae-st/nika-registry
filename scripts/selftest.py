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
import json
import subprocess
from unittest.mock import patch

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

# ── resolve() picks by semver precedence · stable outranks its pre-release ──
check("semver: 0.2.0 > 0.2.0-rc1", get.version_key("0.2.0") > get.version_key("0.2.0-rc1"))
check("semver: 0.10.0 > 0.2.0 (numeric, not lexical)", get.version_key("0.10.0") > get.version_key("0.2.0"))
check("semver: 0.2.0-rc2 > 0.2.0-rc1", get.version_key("0.2.0-rc2") > get.version_key("0.2.0-rc1"))

# ── the consume hand-off must never suggest a command that cannot run ─────────
# A required var makes even a mock preview fail NIKA-VAR-001; the suggestion
# must carry the --var flag. A fetch-only workflow must not be sold as offline.
_h_llm_var = " ".join(get.handoff_lines("w.nika", {"llm_calls": 1, "permits_boundary": "", "vars_required": ["transcript_path"]}))
check("hand-off surfaces a required var in the run command", "--var transcript_path=<value>" in _h_llm_var)
_h_plain = " ".join(get.handoff_lines("w.nika", {"llm_calls": 1, "permits_boundary": "", "vars_required": []}))
check("hand-off omits --var when none required", "--var" not in _h_plain)
_h_fetch = " ".join(get.handoff_lines("w.nika", {"llm_calls": 0, "permits_boundary": "tools: [\"nika:fetch\"]", "vars_required": []}))
check("hand-off never calls a fetch workflow offline", "no network" not in _h_fetch)

# A parser refusal is a reproduced negative result, never an empty capability set.
import cert as certificate  # noqa: E402
import index as catalog_index  # noqa: E402

_parse_report = {"clean": False, "parse_fatal": True, "findings": [
    {"code": "NIKA-PARSE-005", "kind": "parse", "gate": "PARSE", "message": "unknown workflow field"}
]}
with patch.object(certificate.subprocess, "run", return_value=subprocess.CompletedProcess(
        [], 2, json.dumps(_parse_report), "")) as probe:
    _refused = certificate.engine_cert("nika", pathlib.Path("refused.nika"))
check("parse refusal does not infer capabilities from error prose", probe.call_count == 1)
check("parse refusal preserves its structured diagnostic", _refused["findings"][0]["code"] == "NIKA-PARSE-005")
check("parse refusal has unknown permits, broad grants and secret leaks",
      all(_refused[key] is None for key in ("permits_boundary", "broad", "secret_leaks", "vars_required")))
check("parse refusal exec is unknown", certificate.exec_capability(_refused) is None)
check("restricted exec is present", certificate.exec_capability({"permits_boundary": "permits:\n  exec: [echo]"}) is True)
check("explicitly absent exec is absent", certificate.exec_capability({"permits_boundary": "permits:\n  exec: false"}) is False)
check("empty permits mapping has no exec", certificate.exec_capability({"permits_boundary": "permits: {}"}) is False)
check("missing permits evidence is unknown", certificate.exec_capability({"permits_boundary": "{}"}) is None)
_row = {"name": "refused", "publisher": "alice", "version": "1.0.0", "description": "fixture", "tools": [], "cert": _refused}
_rendered = certificate.render_catalog([_row])
check("catalog names parse refusal and unknown exec", "| parse_refused | unknown | unknown | unknown | unknown |" in _rendered)
check("catalog does not call a negative certificate clean", "0 clean · 1 unavailable" in _rendered)
_badge = catalog_index.badge({"cert_summary": {"analysis_status": "parse_refused", "clean": False}, "advisories": []})
check("badge names parse refusal", _badge["message"] == "parse_refused" and _badge["color"] == "orange")
check("refused artifact has no run hand-off", not any(line.startswith("nika run") for line in get.handoff_lines("refused.nika", _refused)))

# Issue #1684 · live workflow sources are `.nika`. Pre-cut immutable
# first-party entries may still pin a `.nika.yaml` path at one vetted
# (repo, rev) tuple. A matching hex on any other repo is not a permit.
PRECUT_REPO, PRECUT_REV = verify.PRECUT_FIRST_PARTY
check("canonical .nika source is accepted", verify.is_canonical_workflow_source("examples/meeting-actions.nika"))
check("project nika.yaml is not a workflow source", not verify.is_canonical_workflow_source("nika.yaml"))
check("empty-stem .nika is not a workflow source", not verify.is_canonical_workflow_source(".nika"))
check("legacy suffix is not canonical", not verify.is_canonical_workflow_source("examples/meeting-actions.nika.yaml"))
check(
    "legacy suffix at first-party pre-cut identity is allowed",
    verify.workflow_source_path_ok("examples/meeting-actions.nika.yaml", PRECUT_REPO, PRECUT_REV),
)
check(
    "legacy suffix at any other rev is refused",
    not verify.workflow_source_path_ok("examples/meeting-actions.nika.yaml", PRECUT_REPO, "0" * 40),
)
check(
    "legacy suffix at a matching rev on another repo is refused",
    not verify.workflow_source_path_ok("examples/meeting-actions.nika.yaml", "alice/unrelated", PRECUT_REV),
)
check("plain yaml is refused", not verify.workflow_source_path_ok("examples/meeting-actions.yaml", PRECUT_REPO, PRECUT_REV))

_spec = os.environ.get("NIKA_SPEC_DIR")
if _spec:
    _head = verify.git_head(_spec)
    _fp = {
        "source": {"repo": PRECUT_REPO, "rev": PRECUT_REV},
        "version": "0.1.0",
    }
    _community = {
        "source": {"repo": "alice/unrelated", "rev": PRECUT_REV},
        "version": "0.1.0",
    }
    _new = {
        "source": {"repo": PRECUT_REPO, "rev": "c119bb42fbacde440f66fcdc745f7bc5b966b627"},
        "version": "0.2.0",
    }
    check(
        "community source.rev does not select the checker",
        verify.oracle_cwd(_spec, _community) == str(pathlib.Path(_spec)),
    )
    check(
        "current first-party 0.2.0 uses the trusted SPEC_PIN checkout",
        verify.oracle_cwd(_spec, _new) == str(pathlib.Path(_spec)),
    )
    _precut_cwd = verify.oracle_cwd(_spec, _fp)
    check(
        "pre-cut first-party tuple uses a vetted oracle whose HEAD is the pin",
        verify.git_head(_precut_cwd) == PRECUT_REV,
    )
    # A poisoned cache with the wrong HEAD must refuse, not run.
    _poison = verify.ROOT / ".verify-oracle" / ("deadbeef" * 5)
    _poison.mkdir(parents=True, exist_ok=True)
    verify._ORACLE_WT["deadbeef" * 5] = str(_poison)
    _raised = False
    try:
        verify.materialize_trusted_oracle(_spec, "deadbeef" * 5)
    except (RuntimeError, subprocess.CalledProcessError):
        _raised = True
    check("oracle cache with wrong HEAD is refused", _raised)
else:
    check("oracle identity tests skipped without NIKA_SPEC_DIR", True)

if FAILED:
    print(f"\nselftest FAILED: {len(FAILED)} check(s)", file=sys.stderr)
    sys.exit(1)
print("\nselftest: all gate guards hold")
