#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2026 SuperNovae Studio <contact@supernovae.studio>
#
# estate.py — the provenance manifest: every tracked file declares what it IS.
#
# OBSERVATION MODE (E0): estate.yaml declares provenance — authored ·
# generated · pinned-copy · foreign — it enforces nothing. The point is to
# make the repo's derivation topology explicit: which files a human writes,
# which files a tool re-derives (and from what, gated by which CI check),
# so drift between "what we believe" and "what is" becomes observable.
#
# Classification is EVIDENCE-driven, never assumed: the script reads the
# generation markers and structural keys inside the files themselves (the
# project_pack.py TOML header · the cert.py CATALOG comment · the index.py
# JSON shapes). A file with no such evidence lands in `authored` with
# `note: unverified-default` — honesty over completeness.
#
# Derived, never authored (the house projection pattern): --write
# regenerates estate.yaml from the tracked tree; --check re-emits and
# byte-compares. On divergence --check exits 5 (the ssot-compiler
# convention — deliberately distinct from the sibling drift gates' exit 1,
# so an estate divergence is distinguishable in CI logs).
#
# Usage:
#   python3 scripts/estate.py --write   # regenerate estate.yaml
#   python3 scripts/estate.py --check   # drift gate (exit 5 on divergence)

import hashlib
import json
import pathlib
import re
import subprocess
import sys
import tomllib

ROOT = pathlib.Path(__file__).resolve().parent.parent
ESTATE = ROOT / "estate.yaml"
ESTATE_SCHEMA = 1
SELF = "scripts/estate.py"

CLASSES = {
    "authored": "a human writes here",
    "generated": "derived by a tool from declared inputs — regenerate, never hand-edit",
    "pinned-copy": "byte-copy pinned to an upstream rev",
    "foreign": "pointer to a third-party sovereign source",
}

VERIFY_YML = ".github/workflows/verify.yml"


def tracked_files() -> list:
    out = subprocess.run(["git", "-C", str(ROOT), "ls-files", "-z"],
                         capture_output=True, check=True)
    files = {f for f in out.stdout.decode().split("\0") if f}
    # The generator always classifies itself; the manifest never lists
    # itself (its sha256 cannot contain its own hash).
    files.add(SELF)
    files.discard("estate.yaml")
    return sorted(files)


def spec_pin_rev() -> str:
    pin = (ROOT / "SPEC_PIN").read_text()
    return next(l.strip() for l in pin.splitlines() if l.strip() and not l.startswith("#"))


def engine_version() -> str:
    m = re.search(r'^ENGINE_VERSION = "([0-9.]+)"', (ROOT / "scripts/cert.py").read_text(), re.M)
    return m.group(1) if m else "unknown"


def index_artifact_keys() -> set:
    try:
        doc = json.loads((ROOT / "index.json").read_text())
        return {(a["publisher"], a["name"]) for a in doc.get("artifacts", [])}
    except Exception:
        return set()


def registry_entry_exists(publisher: str, name: str) -> bool:
    return any((ROOT / "registry").glob(f"*/{publisher}/{name}/*.toml"))


AUTHORED_EVIDENCE = {
    "README.md": "prose entry surface · no generation marker · README.md:102 says only CATALOG.md is generated",
    "POLICIES.md": "prose policy pack (the 8 laws) · no generation marker · gates cite it, nothing writes it",
    "CONTRIBUTING.md": "prose contribution policy · no generation marker",
    "AGENTS.md": "hand-written agent entry per the AGENTS.md convention · no generation marker",
    "ENTRY_TEMPLATE.toml": "the copy-me template for community PRs · its own header says 'Copy to …'",
    "advisories/README.md": "prose advisory format doc · advisories are authored per incident, never derived",
    ".gitignore": "hand-kept ignore list for the scripts' temp dirs (.verify-tmp · .cert-tmp)",
    "SPEC_PIN": "its own header: 'Bump deliberately: edit this' — a hand-bumped pin, the projector's INPUT",
    ".github/CODEOWNERS": "hand-written review policy (maintainer-review is the human gate)",
    ".github/ISSUE_TEMPLATE/advisory.md": "hand-written issue template",
    ".github/pull_request_template.md": "hand-written PR checklist",
    ".github/workflows/verify.yml": "hand-written CI trust model (comments narrate design decisions)",
    ".github/workflows/release-heal.yml": "hand-written bot workflow (it edits OTHER files, nothing writes it)",
    "scripts/verify.py": "hand-written gate · SPDX header + design prose · R1-R7 rules",
    "scripts/cert.py": "hand-written certifier · SPDX header + design prose",
    "scripts/index.py": "hand-written projector · SPDX header + design prose",
    "scripts/project_pack.py": "hand-written projector · SPDX header + design prose",
    "scripts/get.py": "hand-written consume path · SPDX header + design prose",
    "scripts/selftest.py": "hand-written guard assertions · SPDX header + design prose",
    "scripts/orphan_gate.py": "hand-written gate · SPDX header + design prose · POLICIES.md law 8 (check-only by design)",
    SELF: "hand-written estate projector (this manifest's generator)",
}

AUTHORED_NOTES = {
    "scripts/cert.py": "release-heal.yml rewrites the ENGINE_VERSION pin line on engine releases — a bot-maintained field inside an authored file",
    ".github/workflows/verify.yml": "release-heal.yml rewrites the engine download URL + sha256 digest lines — bot-maintained fields inside an authored file",
}


def classify(rel: str, body: bytes) -> dict:
    text = None
    try:
        text = body.decode()
    except UnicodeDecodeError:
        pass

    # registry entries — generated ONLY when the projection header is present.
    if rel.startswith("registry/") and rel.endswith(".toml") and text is not None:
        if text.startswith("# GENERATED by scripts/project_pack.py"):
            rev = spec_pin_rev()
            src = tomllib.loads(text).get("source", {})
            return {
                "class": "generated",
                "evidence": "file header: '# GENERATED by scripts/project_pack.py from the nika-spec pack — do not hand-edit'",
                "derivation": {
                    "tool": "python3 scripts/project_pack.py --write (NIKA_SPEC_DIR=<nika-spec checkout>)",
                    "gate": f"{VERIFY_YML} step 'First-party entries match the spec pack (projection parity)' → python3 scripts/project_pack.py --check",
                    "inputs": [
                        "SPEC_PIN",
                        f"{src.get('repo', '?')}@{rev}:examples/manifest.yaml",
                        f"{src.get('repo', '?')}@{rev}:{src.get('path', '?')}",
                    ],
                },
            }
        return {
            "class": "authored",
            "evidence": "registry entry WITHOUT the project_pack.py header — a community entry authored by PR (CONTRIBUTING.md)",
        }

    if rel == "index.json" and text is not None:
        try:
            doc = json.loads(text)
        except json.JSONDecodeError:
            doc = {}
        if "index_schema" in doc:
            return {
                "class": "generated",
                "evidence": "top-level `index_schema` key = the scripts/index.py build() shape; index.py writes exactly this path in --write",
                "derivation": {
                    "tool": "python3 scripts/index.py --write",
                    "gate": f"{VERIFY_YML} step 'Index + llms.txt + badges in sync' → python3 scripts/index.py --check",
                    "inputs": ["registry/**/*.toml", "certs/**/*.json", "advisories/*.toml"],
                },
            }

    if rel == "llms.txt" and text is not None and text.startswith("# nika-registry"):
        return {
            "class": "generated",
            "evidence": "byte-target of scripts/index.py render_llms() (index.py writes this path in --write; first line matches its template)",
            "derivation": {
                "tool": "python3 scripts/index.py --write",
                "gate": f"{VERIFY_YML} step 'Index + llms.txt + badges in sync' → python3 scripts/index.py --check",
                "inputs": ["registry/**/*.toml", "certs/**/*.json", "advisories/*.toml"],
            },
        }

    if rel == "CATALOG.md" and text is not None and "<!-- GENERATED by scripts/cert.py" in text:
        ver = engine_version()
        return {
            "class": "generated",
            "evidence": "in-file marker: '<!-- GENERATED by scripts/cert.py --write — do not hand-edit'",
            "derivation": {
                "tool": f"python3 scripts/cert.py --write (NIKA_BIN=nika {ver})",
                "gate": f"{VERIFY_YML} step 'Certs + catalog in sync (the engine's own analysis, re-proven)' → python3 scripts/cert.py --check",
                "inputs": ["registry/**/*.toml", f"pinned artifact bytes at each entry's source.repo@source.rev:source.path", f"nika {ver} static analysis"],
            },
        }

    if rel.startswith("badges/") and rel.endswith(".json") and text is not None:
        try:
            doc = json.loads(text)
        except json.JSONDecodeError:
            doc = {}
        if doc.get("schemaVersion") == 1 and "label" in doc:
            base = {
                "class": "generated",
                "evidence": f"shields.io endpoint shape (schemaVersion=1 · label='{doc['label']}') = exactly what scripts/index.py badge()/main() emit",
                "derivation": {
                    "tool": "python3 scripts/index.py --write",
                    "gate": f"{VERIFY_YML} step 'Index + llms.txt + badges in sync' → python3 scripts/index.py --check",
                    "inputs": ["registry/**/*.toml", "certs/**/*.json", "advisories/*.toml"],
                },
            }
            stem = pathlib.Path(rel).stem
            if stem != "catalog" and "--" in stem:
                pub, name = stem.split("--", 1)
                if (pub, name) not in index_artifact_keys():
                    base["derivation"]["gate"] = "NONE — index.py --check only re-derives badges for in-index artifacts; this file is no longer re-proven"
                    base["note"] = f"orphan · {pub}/{name} is absent from registry/ and index.json — a leftover projection, stale relative to current inputs"
            return base

    if rel.startswith("certs/") and rel.endswith(".json") and text is not None:
        try:
            doc = json.loads(text)
        except json.JSONDecodeError:
            doc = {}
        if "certificate" in doc and "engine" in doc:
            parts = pathlib.Path(rel).parts  # certs/<publisher>/<name>/<version>.json
            pub, name = parts[1], parts[2]
            eng = doc["engine"]
            base = {
                "class": "generated",
                "evidence": f"cert JSON shape (engine={eng} · certificate · sha256) = exactly what scripts/cert.py emits; its `entry` field cites {doc.get('entry', '?')}",
                "derivation": {
                    "tool": f"python3 scripts/cert.py --write (NIKA_BIN=nika {eng})",
                    "gate": f"{VERIFY_YML} step 'Certs + catalog in sync (the engine's own analysis, re-proven)' → python3 scripts/cert.py --check",
                    "inputs": [doc.get("entry", "?"), f"pinned artifact bytes (sha256 {doc.get('sha256', '?')[:12]}…)", f"nika {eng} static analysis"],
                },
            }
            if not registry_entry_exists(pub, name):
                base["derivation"]["gate"] = "NONE — cert.py --check only iterates registry/**/*.toml; with the entry gone this cert is no longer re-proven"
                base["derivation"]["inputs"][0] = f"{doc.get('entry', '?')} (ABSENT from the tree)"
                base["note"] = f"orphan · {pub}/{name} has no registry entry — a leftover projection, stale relative to current inputs"
            return base

    if rel in AUTHORED_EVIDENCE:
        out = {"class": "authored", "evidence": AUTHORED_EVIDENCE[rel]}
        if rel in AUTHORED_NOTES:
            out["note"] = AUTHORED_NOTES[rel]
        return out

    # Advisories are authored per incident (advisories/README.md format).
    if rel.startswith("advisories/") and rel.endswith(".toml"):
        return {"class": "authored",
                "evidence": "an advisory is authored per incident (advisories/README.md · OSV-inspired TOML), never derived"}

    # No evidence → honesty over completeness.
    return {"class": "authored", "evidence": "no generation marker or known role found",
            "note": "unverified-default"}


def q(s) -> str:
    """A JSON string is a valid YAML scalar — deterministic quoting for free."""
    return json.dumps(s, ensure_ascii=False)


def render() -> str:
    rows = []
    counts = {c: 0 for c in CLASSES}
    unverified = 0
    for rel in tracked_files():
        body = (ROOT / rel).read_bytes()
        row = classify(rel, body)
        row["path"] = rel
        row["sha256"] = hashlib.sha256(body).hexdigest()
        counts[row["class"]] += 1
        if row.get("note") == "unverified-default":
            unverified += 1
        rows.append(row)

    lines = [
        "# GENERATED by scripts/estate.py — do not hand-edit.",
        "# The estate manifest: every tracked file declares its provenance.",
        "# OBSERVATION MODE (E0): this declares what IS — it enforces nothing.",
        "# Re-generate: python3 scripts/estate.py --write",
        "# Check:       python3 scripts/estate.py --check   (re-emits · byte-compares · exit 5 on divergence)",
        f"estate_schema: {ESTATE_SCHEMA}",
        "mode: observation",
        "repo: supernovae-st/nika-registry",
        "classes:",
    ]
    for c in CLASSES:
        lines.append(f"  {c}: {q(CLASSES[c])}")
    lines.append("summary:")
    for c in CLASSES:
        lines.append(f"  {c}: {counts[c]}")
    lines.append(f"  unverified-default: {unverified}")
    lines.append("files:")
    for row in rows:
        lines.append(f"- path: {q(row['path'])}")
        lines.append(f"  class: {row['class']}")
        lines.append(f"  sha256: {row['sha256']}")
        lines.append(f"  evidence: {q(row['evidence'])}")
        if "derivation" in row:
            d = row["derivation"]
            lines.append("  derivation:")
            lines.append(f"    tool: {q(d['tool'])}")
            lines.append(f"    gate: {q(d['gate'])}")
            lines.append("    inputs:")
            for i in d["inputs"]:
                lines.append(f"    - {q(i)}")
        if "note" in row:
            lines.append(f"  note: {q(row['note'])}")
    return "\n".join(lines) + "\n"


def main() -> int:
    mode = sys.argv[1] if len(sys.argv) > 1 else "--check"
    if mode not in ("--write", "--check"):
        print(f"estate.py: unknown mode {mode!r} (--write | --check)", file=sys.stderr)
        return 2
    rendered = render()
    if mode == "--write":
        ESTATE.write_text(rendered)
        n = rendered.count("\n- path: ")
        print(f"✓ estate.yaml · {n} files classified")
        return 0
    if not ESTATE.is_file() or ESTATE.read_text() != rendered:
        print("✗ estate drift · estate.yaml diverges from the tracked tree — run scripts/estate.py --write", file=sys.stderr)
        return 5
    print("✓ estate.yaml in sync with the tracked tree")
    return 0


if __name__ == "__main__":
    sys.exit(main())
