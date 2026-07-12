<p align="center">
  <a href="https://nika.sh">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://nika.sh/brand/nika-logo-dark.svg">
      <img src="https://nika.sh/brand/nika-logo-light.svg" alt="Nika" width="220">
    </picture>
  </a>
</p>

# nika-registry

[![verify](https://github.com/supernovae-st/nika-registry/actions/workflows/verify.yml/badge.svg)](https://github.com/supernovae-st/nika-registry/actions/workflows/verify.yml)
[![contract](https://img.shields.io/badge/contract-registry--v0.1-blue)](https://github.com/supernovae-st/nika-spec/blob/main/registry/registry-v0.1.md)
[![catalog](https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fsupernovae-st%2Fnika-registry%2Fmain%2Fbadges%2Fcatalog.json)](CATALOG.md)

**Share Nika artifacts: workflows · packs · skills · agents: where every
entry is machine-re-proven, not gatekeeper-trusted.**

Every marketplace answers "is this safe?" with stars, downloads or moderators.
This registry answers with a **proof you re-run yourself**: each entry pins
its source to a full commit + a full sha256, and CI re-fetches the bytes,
re-hashes them, and re-runs the [conformance oracle](https://github.com/supernovae-st/nika-spec)
on every PR and every night. The `[cert]` block in an entry is informative -
**the proof is `scripts/verify.py`, and you can run it offline against a
mirror.** Trust lives in the artifact, not in this repo.

## Install: the engine pulls it natively °

```sh
nika check registry:supernovae-st/meeting-actions   # fetch → verify digest → cache → the full audit ladder
nika run   registry:supernovae-st/meeting-actions   # same seam: nothing executes before audit-before-run
```

The verified file lands under `~/.nika/registry/<owner>/<name>/` and a cache
hit works offline; a digest mismatch refuses hard. ° ships in the next
release — until then, the auditable script below does the same job today.

## Or: one auditable script

```sh
git clone https://github.com/supernovae-st/nika-registry && cd nika-registry
python3 scripts/get.py --list                 # what exists
python3 scripts/get.py meeting-actions        # fetch → verify sha256 → local audit → done
```

`get.py` refuses on any mismatch (hash · advisory · overwrite) and never
executes anything: a workflow lands on disk and **you** decide to run it.
Not `curl | sh`: you cloned the repo, you can read the 140 lines first.

**Agents**: one fetch of [`index.json`](index.json) carries every artifact
with its pin, digest, cert summary and advisory state; [`llms.txt`](llms.txt)
teaches the consume/verify path in agent-readable form.

**Badges**: every artifact has a live cert badge -
`https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/supernovae-st/nika-registry/main/badges/<publisher>--<name>.json`

## Publish (a PR)

Your artifact stays in **your** git repo: the registry stores a pointer,
a digest and a proof, never a copy. Namespace = repo ownership (the Go
model): `registry/workflows/<your-github-owner>/<name>/<version>.toml`,
and CI refuses an entry whose publisher does not own the source repo.

1. Make your workflow pass `nika check` (or `conformance/runner.py validate`).
2. Add the entry file (copy ENTRY_TEMPLATE.toml (or any seed entry)).
3. Open a PR: CI re-proves it (hash · oracle · secrets · license · namespace).

## Where the first-party artifacts come from

The `supernovae-st/*` entries are **not** a hand-kept list: they are a
**projection of the spec's canonical pack** (`scripts/project_pack.py` ·
gated `--check` in CI). Add a showcase to
[nika-spec](https://github.com/supernovae-st/nika-spec), re-run the
projector, it publishes here: the registry cannot diverge from the pack.
Community artifacts stay authored by PR.

## The contract

This registry implements **[registry-v0.1](https://github.com/supernovae-st/nika-spec/blob/main/registry/registry-v0.1.md)**,
the normative sharing contract in the Apache-2.0 spec: anyone can run a
conformant registry (org-internal, mirror, fork) and clients speak to all
of them identically.

## The rules (each maps to a documented registry death)

| Rule | Kills |
|---|---|
| Entries are **immutable**: new version = new file · withdrawal = an [advisory](advisories/), never a delete | left-pad · rug-pulls |
| **Full-commit + full-sha256 pinning**: no tags, no branches | tj-actions tag rewrite |
| CI **re-hashes the fetched bytes** | manifest confusion |
| CI **re-runs the oracle** | the class nobody else catches: broken/lying artifacts |
| **Key-shaped strings refuse the gate** | the n8n shared-template credential leak |
| **Namespace = source ownership** | dependency confusion · typosquatting |
| **Zero install-time execution**: entries and artifacts are data | event-stream · Shai-Hulud · ComfyUI |

Before running ANY shared workflow, read its `permits:` and `exec:` blocks -
`nika check` shows you the full effect surface (network · fs · secrets · cost)
**before a single token is spent**. That is the point of Nika.

## The catalog · certificates

[`CATALOG.md`](CATALOG.md) is generated by the ENGINE's static analysis of
every pinned artifact (`scripts/cert.py` · engine version pinned by digest
in CI): can it exec? which tools? how many LLM calls? what cost ceiling?
Each row links a machine cert under [`certs/`](certs/). No other workflow
registry can produce this column: and you never have to trust it: the
cert re-derives locally with `nika check`.

**"clean" is not "safe".** A cert proves the effect stays inside the
workflow's *declared* permits: it cannot vet what a permitted program or
tool actually does. An **unbounded grant** (`exec: true` runs any program ·
a `*` tool allows any tool) is marked **⚠** on every surface; there, "what
it can do" is effectively "anything in that category", so read the workflow
before you run it. ⚠ flags a grant to inspect, not a verdict of unsafe.

## Yanking · advisories

A compromised or broken version is **never deleted** (reproducibility): it
gets an advisory in [`advisories/`](advisories/) (OSV-inspired), which
consumers and future `nika add` check at install time.

## License

Registry metadata: Apache-2.0. Each artifact carries its own `license` field.
