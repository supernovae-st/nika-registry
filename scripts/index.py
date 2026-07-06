#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2026 SuperNovae Studio <contact@supernovae.studio>
#
# index.py — the machine aggregate: ONE fetch = the whole registry.
#
# Agents and tools should not have to crawl a directory tree. index.json
# carries every entry (pinned source + digest), its cert summary, and the
# advisory state — everything needed to resolve, verify and install any
# artifact, in a single GET:
#
#   https://raw.githubusercontent.com/supernovae-st/nika-registry/main/index.json
#
# Derived, never authored (the house projection pattern): --write
# regenerates from registry/ + certs/ + advisories/, --check gates parity
# in CI. The index is a convenience — the lockable truth stays the entry
# files and YOUR local re-verification; a tampered index cannot lie about
# bytes because consumers pin hashes, not names (see README · trust model).
#
# Also projected here (research pass 2026-07-06 · registry-DX):
#   badges/<publisher>--<name>.json   shields.io endpoint format — live
#                                     cert badges, embeddable anywhere
#   llms.txt                          the AI-agent teaching surface
#                                     (llmstxt.org · markdown + links)

import json
import pathlib
import sys
import tomllib

ROOT = pathlib.Path(__file__).resolve().parent.parent
INDEX_SCHEMA = 1


def build() -> dict:
    advisories = {}
    for p in sorted(ROOT.glob("advisories/*.toml")):
        a = tomllib.loads(p.read_text())
        for v in a["versions"]:
            advisories.setdefault(f"{a['affected']}@{v}", []).append(a["id"])

    artifacts = []
    for p in sorted(ROOT.glob("registry/**/*.toml")):
        e = tomllib.loads(p.read_text())
        key = f"{e['type']}s/{e['publisher']}/{e['name']}"
        cert_path = ROOT / "certs" / e["publisher"] / e["name"] / f"{e['version']}.json"
        cert = None
        if cert_path.is_file():
            full = json.loads(cert_path.read_text())["certificate"]
            cert = {
                "clean": full["clean"],
                "llm_calls": full["llm_calls"],
                "exec": "exec: true" in full["permits_boundary"],
                "cost_usd_bounded": None if full["cost_usd"]["has_unbounded"] else full["cost_usd"]["bounded_total"],
                "secret_leaks": len(full["secret_leaks"]),
            }
        artifacts.append({
            "type": e["type"],
            "name": e["name"],
            "publisher": e["publisher"],
            "version": e["version"],
            "description": e["description"],
            "license": e["license"],
            "spec": e["spec"],
            "source": e["source"],
            "sha256": e["integrity"]["sha256"],
            "entry": str(p.relative_to(ROOT)),
            "cert": str(cert_path.relative_to(ROOT)) if cert_path.is_file() else None,
            "cert_summary": cert,
            "advisories": advisories.get(f"{key}@{e['version']}", []),
        })

    return {
        "index_schema": INDEX_SCHEMA,
        "registry": "supernovae-st/nika-registry",
        "verify": {
            "how": "fetch source.repo@source.rev:source.path · sha256 MUST equal .sha256 · then `nika check <file>` locally",
            "raw_template": "https://raw.githubusercontent.com/{source.repo}/{source.rev}/{source.path}",
            "never": "install anything an advisory names · trust this index over your own hash check",
        },
        "artifacts": artifacts,
    }


RAW = "https://raw.githubusercontent.com/supernovae-st/nika-registry/main"


def badge(a: dict) -> dict:
    """One shields.io endpoint document per artifact — the cert as a badge."""
    c = a["cert_summary"]
    if not c:
        return {"schemaVersion": 1, "label": "nika cert", "message": "none", "color": "lightgrey"}
    if a["advisories"]:
        return {"schemaVersion": 1, "label": "nika cert", "message": "yanked", "color": "red"}
    if not c["clean"]:
        return {"schemaVersion": 1, "label": "nika cert", "message": "findings", "color": "orange"}
    cost = "cost unbounded" if c["cost_usd_bounded"] is None else f"≤ ${c['cost_usd_bounded']:.2f}/run"
    msg = f"clean · {cost}" + (" · exec ⚠" if c["exec"] else "")
    return {"schemaVersion": 1, "label": "nika cert", "message": msg,
            "color": "yellow" if c["exec"] else "brightgreen"}


def render_llms(doc: dict) -> str:
    lines = [
        "# nika-registry",
        "",
        "> Share Nika workflows/packs/skills/agents where every entry is",
        "> machine-re-proven: pinned to a full commit + sha256, re-verified by",
        "> the conformance oracle in CI, certified by the engine's static",
        "> analysis (exec · tools · cost · permits) BEFORE anything runs.",
        "> Entries are immutable; withdrawal is an advisory, never a delete.",
        "",
        "To install an artifact: fetch its pinned bytes from the author's repo",
        "at the pinned rev, verify sha256 equals the entry digest, run",
        "`nika check <file>` locally, only then `nika run`. `scripts/get.py`",
        "automates exactly these steps and refuses on any mismatch. NEVER",
        "install a name an LLM suggested without resolving it here first",
        "(slopsquatting), and NEVER skip the hash check.",
        "",
        "## Machine surfaces",
        "",
        f"- [index.json]({RAW}/index.json): every artifact — source pin, sha256, cert summary, advisories — in one fetch",
        f"- [CATALOG.md]({RAW}/CATALOG.md): the human storefront (generated by the engine's analysis)",
        f"- [Entry format]({RAW}/CONTRIBUTING.md): how to publish (a PR · CI re-proves it)",
        "",
        "## Artifacts",
        "",
    ]
    for a in doc["artifacts"]:
        c = a["cert_summary"] or {}
        cost = "unbounded" if not c or c.get("cost_usd_bounded") is None else f"≤${c['cost_usd_bounded']:.2f}"
        execs = " · exec⚠" if c.get("exec") else ""
        lines.append(
            f"- [{a['publisher']}/{a['name']}@{a['version']}]({RAW}/{a['entry']}): "
            f"{a['description']} (llm={c.get('llm_calls', '?')} · {cost}{execs})"
        )
    lines += [
        "",
        "## Optional",
        "",
        f"- [Advisories]({RAW}/advisories/README.md): the withdrawal surface — check before every install",
        "- [The spec](https://github.com/supernovae-st/nika-spec): the language + the conformance oracle",
        "- [The engine](https://github.com/supernovae-st/nika): `brew install supernovae-st/tap/nika`",
        "",
    ]
    return "\n".join(lines)


def main() -> int:
    mode = sys.argv[1] if len(sys.argv) > 1 else "--check"
    doc = build()
    targets = {ROOT / "index.json": json.dumps(doc, indent=2, sort_keys=True) + "\n",
               ROOT / "llms.txt": render_llms(doc)}
    for a in doc["artifacts"]:
        targets[ROOT / "badges" / f"{a['publisher']}--{a['name']}.json"] =             json.dumps(badge(a), indent=2, sort_keys=True) + "\n"
    n = len(doc["artifacts"])
    clean = sum(1 for a in doc["artifacts"] if (a["cert_summary"] or {}).get("clean") and not a["advisories"])
    targets[ROOT / "badges" / "catalog.json"] = json.dumps({
        "schemaVersion": 1, "label": "artifacts",
        "message": f"{n} · {clean} certified clean",
        "color": "brightgreen" if clean == n else "yellow",
    }, indent=2, sort_keys=True) + "\n"

    drift = False
    for out, rendered in targets.items():
        if mode == "--write":
            out.parent.mkdir(parents=True, exist_ok=True)
            out.write_text(rendered)
        elif not out.is_file() or out.read_text() != rendered:
            print(f"✗ drift · {out.relative_to(ROOT)} — run scripts/index.py --write", file=sys.stderr)
            drift = True
    if mode == "--write":
        print(f"✓ index.json + llms.txt + {len(doc['artifacts'])} badges")
        return 0
    if not drift:
        print(f"✓ index + llms.txt + badges in sync ({len(doc['artifacts'])} artifacts)")
    return 1 if drift else 0


if __name__ == "__main__":
    sys.exit(main())
