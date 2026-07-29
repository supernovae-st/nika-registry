# SPDX-License-Identifier: AGPL-3.0-or-later
# Copyright (C) 2026 SuperNovae Studio <contact@supernovae.studio>
#
# Per-repo estate rules. The tool is shared and lives in nika-estate; these
# declarations are ours. FILES carries the per-file exceptions, PATTERNS the
# ordered globs that cover everything else (first match wins).
#
# This repo enumerates far more than it globs, and that is correct rather
# than lazy: every cert cites the artifact it certified, every projected
# entry cites the spec rev it came from, and a badge whose registry entry has
# been deleted is a leftover projection nothing re-proves. None of that
# survives being flattened into a glob with one shared evidence string, so
# the rows below are COMPUTED from what each file actually contains, exactly
# as the schema-1 classify() did.
#
# The tool hands down ROOT, SELF, RULES and CLASSES before executing this.

import json
import pathlib
import re
import subprocess
import tomllib

VERIFY_YML = ".github/workflows/verify.yml"
HEAL_YML = ".github/workflows/release-heal.yml"

_INDEX_GATE = (f"{VERIFY_YML} step 'Index + llms.txt + badges in sync' "
               "→ python3 scripts/index.py --check")
_INDEX_INPUTS = ["registry/**/*.toml", "certs/**/*.json", "advisories/*.toml"]
_CERT_GATE = (f"{VERIFY_YML} step 'Certs + catalog in sync (the engine's own analysis, "
              "re-proven)' → python3 scripts/cert.py --check")


def _tracked() -> list:
    out = subprocess.run(["git", "-C", str(ROOT), "ls-files", "-z"],  # noqa: F821
                         capture_output=True, check=True)
    return sorted(f for f in out.stdout.decode().split("\0") if f)


def _text(rel: str):
    try:
        return (ROOT / rel).read_text()  # noqa: F821
    except (UnicodeDecodeError, OSError):
        return None


def _spec_pin_rev() -> str:
    pin = (ROOT / "SPEC_PIN").read_text()  # noqa: F821
    return next(l.strip() for l in pin.splitlines() if l.strip() and not l.startswith("#"))


def _engine_version() -> str:
    m = re.search(r'^ENGINE_VERSION = "([0-9.]+)"',
                  (ROOT / "scripts/cert.py").read_text(), re.M)  # noqa: F821
    return m.group(1) if m else "unknown"


def _index_artifact_keys() -> set:
    try:
        doc = json.loads((ROOT / "index.json").read_text())  # noqa: F821
        return {(a["publisher"], a["name"]) for a in doc.get("artifacts", [])}
    except Exception:
        return set()


def _registry_entry_exists(publisher: str, name: str) -> bool:
    return any((ROOT / "registry").glob(f"*/{publisher}/{name}/*.toml"))  # noqa: F821


# The named roles. SPEC_PIN finally gets the word schema 1 did not have: its
# own header says "Bump deliberately: edit this", and it is the INPUT every
# projection derives from. That is `authored-pin`, not `authored`.
_AUTHORED = {
    "README.md": "prose entry surface · no generation marker · README.md:102 says only CATALOG.md is generated",
    "POLICIES.md": "prose policy pack (the 8 laws) · no generation marker · gates cite it, nothing writes it",
    "CONTRIBUTING.md": "prose contribution policy · no generation marker",
    "AGENTS.md": "hand-written agent entry per the AGENTS.md convention · no generation marker",
    "ENTRY_TEMPLATE.toml": "the copy-me template for community PRs · its own header says 'Copy to …'",
    "advisories/README.md": "prose advisory format doc · advisories are authored per incident, never derived",
    ".gitignore": "hand-kept ignore list for the scripts' temp dirs (.verify-tmp · .cert-tmp)",
    ".github/CODEOWNERS": "hand-written review policy (maintainer-review is the human gate)",
    ".github/ISSUE_TEMPLATE/advisory.md": "hand-written issue template",
    ".github/pull_request_template.md": "hand-written PR checklist",
    VERIFY_YML: "hand-written CI trust model (comments narrate design decisions)",
    HEAL_YML: "hand-written bot workflow (it edits OTHER files, nothing writes it)",
    "scripts/verify.py": "hand-written gate · SPDX header + design prose · R1-R7 rules",
    "scripts/cert.py": "hand-written certifier · SPDX header + design prose",
    "scripts/index.py": "hand-written projector · SPDX header + design prose",
    "scripts/project_pack.py": "hand-written projector · SPDX header + design prose",
    "scripts/get.py": "hand-written consume path · SPDX header + design prose",
    "scripts/selftest.py": "hand-written guard assertions · SPDX header + design prose",
    "scripts/orphan_gate.py": "hand-written gate · SPDX header + design prose · POLICIES.md law 8 (check-only by design)",
    RULES: "hand-written per-repo estate rules (this file) · the tool is shared, these declarations are ours",  # noqa: F821
}

_NOTES = {
    "scripts/cert.py": "release-heal.yml rewrites the ENGINE_VERSION pin line on engine releases — a bot-maintained field inside an authored file",
    VERIFY_YML: "release-heal.yml rewrites the engine download URL + sha256 digest lines — bot-maintained fields inside an authored file",
}


# ── FILES · computed from what each file actually contains ──────────────────

_MIRROR_ROWS = [
    {"path": SELF, "class": "pinned-copy", "evidence": "the shared estate tool, mirrored byte-for-byte from supernovae-st/nika-estate · editing it here is a lost gesture: change it upstream, bump ESTATE_PIN, re-mirror",
      "derivation": {
            "tool": "curl the tool from nika-estate at the rev named in ESTATE_PIN",
            "gate": "the `mirror` job byte-compares scripts/estate.py against nika-estate@ESTATE_PIN and fails the run on any difference",
            "inputs": ["ESTATE_PIN", "supernovae-st/nika-estate@<ESTATE_PIN>:scripts/estate.py"],
        }},
    {"path": "ESTATE_PIN", "class": "authored-pin",
      "evidence": "its own header: 'Bump deliberately: edit this' \u00b7 the rev the shared estate tool is mirrored from, and the INPUT the mirror gate compares against"},
]

FILES = []
_seen = set()


def _add(row):
    if row["path"] in _seen:
        return
    _seen.add(row["path"])
    FILES.append(row)


_REV = _spec_pin_rev()
_ENG = _engine_version()
_KEYS = _index_artifact_keys()

for _rel in _tracked():
    if _rel == "estate.yaml":
        continue
    _t = _text(_rel)

    # Registry entries: generated ONLY when the projection header is present.
    if _rel.startswith("registry/") and _rel.endswith(".toml") and _t is not None:
        if _t.startswith("# GENERATED by scripts/project_pack.py"):
            _src = tomllib.loads(_t).get("source", {})
            _add({"path": _rel, "class": "generated",
                  "evidence": "file header: '# GENERATED by scripts/project_pack.py from the nika-spec pack — do not hand-edit'",
                  "derivation": {
                      "tool": "python3 scripts/project_pack.py --write (NIKA_SPEC_DIR=<nika-spec checkout>)",
                      "gate": f"{VERIFY_YML} step 'First-party entries match the spec pack (projection parity)' → python3 scripts/project_pack.py --check",
                      "inputs": ["SPEC_PIN",
                                 f"{_src.get('repo', '?')}@{_REV}:examples/manifest.yaml",
                                 f"{_src.get('repo', '?')}@{_REV}:{_src.get('path', '?')}"],
                  }})
        else:
            _add({"path": _rel, "class": "authored",
                  "evidence": "registry entry WITHOUT the project_pack.py header — a community entry authored by PR (CONTRIBUTING.md)"})
        continue

    if _rel == "index.json" and _t is not None:
        try:
            _doc = json.loads(_t)
        except json.JSONDecodeError:
            _doc = {}
        if "index_schema" in _doc:
            _add({"path": _rel, "class": "generated",
                  "evidence": "top-level `index_schema` key = the scripts/index.py build() shape; index.py writes exactly this path in --write",
                  "derivation": {"tool": "python3 scripts/index.py --write",
                                 "gate": _INDEX_GATE, "inputs": _INDEX_INPUTS}})
            continue

    if _rel == "llms.txt" and _t is not None and _t.startswith("# nika-registry"):
        _add({"path": _rel, "class": "generated",
              "evidence": "byte-target of scripts/index.py render_llms() (index.py writes this path in --write; first line matches its template)",
              "derivation": {"tool": "python3 scripts/index.py --write",
                             "gate": _INDEX_GATE, "inputs": _INDEX_INPUTS}})
        continue

    if _rel == "CATALOG.md" and _t is not None and "<!-- GENERATED by scripts/cert.py" in _t:
        _add({"path": _rel, "class": "generated",
              "evidence": "in-file marker: '<!-- GENERATED by scripts/cert.py --write — do not hand-edit'",
              "derivation": {
                  "tool": f"python3 scripts/cert.py --write (NIKA_BIN=nika {_ENG})",
                  "gate": _CERT_GATE,
                  "inputs": ["registry/**/*.toml",
                             "pinned artifact bytes at each entry's source.repo@source.rev:source.path",
                             f"nika {_ENG} static analysis"],
              }})
        continue

    # Badges: shields.io endpoints. A badge whose artifact left the index is
    # an orphan — index.py --check no longer re-derives it, so say so.
    if _rel.startswith("badges/") and _rel.endswith(".json") and _t is not None:
        try:
            _doc = json.loads(_t)
        except json.JSONDecodeError:
            _doc = {}
        if _doc.get("schemaVersion") == 1 and "label" in _doc:
            _row = {"path": _rel, "class": "generated",
                    "evidence": f"shields.io endpoint shape (schemaVersion=1 · label='{_doc['label']}') = exactly what scripts/index.py badge()/main() emit",
                    "derivation": {"tool": "python3 scripts/index.py --write",
                                   "gate": _INDEX_GATE, "inputs": list(_INDEX_INPUTS)}}
            _stem = pathlib.Path(_rel).stem
            if _stem != "catalog" and "--" in _stem:
                _pub, _name = _stem.split("--", 1)
                if (_pub, _name) not in _KEYS:
                    _row["derivation"]["gate"] = "NONE — index.py --check only re-derives badges for in-index artifacts; this file is no longer re-proven"
                    _row["note"] = f"orphan · {_pub}/{_name} is absent from registry/ and index.json — a leftover projection, stale relative to current inputs"
            _add(_row)
            continue

    # Certs: the engine's own static analysis, sealed. Same orphan logic.
    if _rel.startswith("certs/") and _rel.endswith(".json") and _t is not None:
        try:
            _doc = json.loads(_t)
        except json.JSONDecodeError:
            _doc = {}
        if "certificate" in _doc and "engine" in _doc:
            _parts = pathlib.Path(_rel).parts   # certs/<publisher>/<name>/<version>.json
            _pub, _name = _parts[1], _parts[2]
            _e = _doc["engine"]
            _row = {"path": _rel, "class": "generated",
                    "evidence": f"cert JSON shape (engine={_e} · certificate · sha256) = exactly what scripts/cert.py emits; its `entry` field cites {_doc.get('entry', '?')}",
                    "derivation": {
                        "tool": f"python3 scripts/cert.py --write (NIKA_BIN=nika {_e})",
                        "gate": _CERT_GATE,
                        "inputs": [_doc.get("entry", "?"),
                                   f"pinned artifact bytes (sha256 {_doc.get('sha256', '?')[:12]}…)",
                                   f"nika {_e} static analysis"],
                    }}
            if not _registry_entry_exists(_pub, _name):
                _row["derivation"]["gate"] = "NONE — cert.py --check only iterates registry/**/*.toml; with the entry gone this cert is no longer re-proven"
                _row["derivation"]["inputs"][0] = f"{_doc.get('entry', '?')} (ABSENT from the tree)"
                _row["note"] = f"orphan · {_pub}/{_name} has no registry entry — a leftover projection, stale relative to current inputs"
            _add(_row)
            continue

# The pin: schema 1 had to call this `authored`. It is the INPUT every
# projection in this repo derives from, advanced deliberately by hand.
_add({"path": "SPEC_PIN", "class": "authored-pin",
      "evidence": "its own header: 'Bump deliberately: edit this' — a hand-bumped pin, the projector's INPUT",
      "note": f"currently pinned at {_REV}"})

# The Apache text, placed verbatim. No human here wrote it.
_add({"path": "LICENSE", "class": "pinned-copy",
      "evidence": "verbatim Apache License 2.0 text, placed here byte for byte · no human in this repo wrote it, which is why it is not authored",
      "derivation": {
          "tool": "hand-placed from the canonical Apache-2.0 text",
          "gate": "NONE — no step re-fetches the upstream text; the SPDX identifier in every source header is the only cross-check",
          "inputs": ["https://www.apache.org/licenses/LICENSE-2.0.txt (Apache-2.0, verbatim)"],
      }})

# Shell completions: clap_complete output, copied in. Nothing in this repo
# re-derives them, and the engine version they were cut from is not recorded
# anywhere — both facts belong in the manifest rather than in nobody's head.
_COMPLETIONS = {
    "completions/_nika": "zsh completion emitted by clap_complete (its own first line is '#compdef nika', followed by clap's 'autoload -U is-at-least' preamble)",
    "completions/nika.bash": "bash completion emitted by clap_complete (the generated _nika() function with COMPREPLY and clap's BASH_VERSINFO guard)",
    "completions/nika.fish": "fish completion emitted by clap_complete (its generated __fish_nika_global_optspecs helper)",
}
for _rel, _ev in _COMPLETIONS.items():
    if _rel in set(_tracked()):
        _add({"path": _rel, "class": "generated", "evidence": _ev,
              "derivation": {
                  "tool": "nika completions <shell> (the engine's clap_complete surface — the tool does NOT live in this repo)",
                  "gate": "NONE — no workflow or script here re-emits these; they were committed once and drift silently as the CLI grows",
                  "inputs": ["the nika CLI verb tree at the engine version they were cut from (NOT recorded — no marker in the files, no pin in this repo)"],
              },
              "note": "the engine version behind these bytes is undeclared · a new verb or flag on the engine leaves them stale with nothing to say so"})

for _rel, _ev in _AUTHORED.items():
    _row = {"path": _rel, "class": "authored", "evidence": _ev}
    if _rel in _NOTES:
        _row["note"] = _NOTES[_rel]
    _add(_row)


# ── PATTERNS · ordered, first match wins, over everything FILES did not take ─

PATTERNS = [
    {"glob": "advisories/**.toml", "class": "authored",
     "evidence": "an advisory is authored per incident (advisories/README.md · OSV-inspired TOML), never derived"},

    # Totality. Anything reaching here has no evidence at all: honesty over
    # completeness, and the coverage check would exit 3 rather than guess.
    {"glob": "**", "class": "authored",
     "evidence": "no generation marker or known role found",
     "note": "unverified-default"},
]

for _r in _MIRROR_ROWS:
    _add(_r)
