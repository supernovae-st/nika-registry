<p align="center">
  <a href="https://nika.sh">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://nika.sh/brand/nika-logo-dark.svg">
      <img src="https://nika.sh/brand/nika-logo-light.svg" alt="Nika" width="220">
    </picture>
  </a>
</p>

<h1 align="center">registry:owner/name@version</h1>

<p align="center">
  <strong>The registry of Nika workflows: a pinned coordinate in, a re-proven artifact out.</strong><br>
  Every entry pins a full commit and a sha256 in its publisher's repository; CI re-fetches the bytes, re-hashes them, re-judges them and re-certifies them. Nothing here is trusted, everything is re-proven.
</p>

<p align="center">
  <a href="https://github.com/supernovae-st/nika-registry/actions/workflows/verify.yml"><img src="https://github.com/supernovae-st/nika-registry/actions/workflows/verify.yml/badge.svg?branch=main" alt="verify: the re-proof"></a>
  <a href="CATALOG.md"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fsupernovae-st%2Fnika-registry%2Fmain%2Fbadges%2Fcatalog.json" alt="artifacts re-proven"></a>
  <a href="https://github.com/supernovae-st/nika-spec/blob/main/registry/registry-v0.1.md"><img src="https://img.shields.io/badge/contract-registry--v0.1-blue" alt="contract registry-v0.1"></a>
  <a href="https://github.com/supernovae-st/nika/releases/latest"><img src="https://img.shields.io/github/v/release/supernovae-st/nika?label=engine" alt="Engine release"></a>
  <a href="https://docs.nika.sh"><img src="https://img.shields.io/badge/docs-docs.nika.sh-8b8cf8.svg" alt="Documentation"></a>
</p>

<p align="center">
  <a href="https://scorecard.dev/viewer/?uri=github.com/supernovae-st/nika-registry"><img src="https://api.scorecard.dev/projects/github.com/supernovae-st/nika-registry/badge" alt="OpenSSF Scorecard"></a>
  <a href="https://archive.softwareheritage.org/browse/origin/?origin_url=https://github.com/supernovae-st/nika-registry"><img src="https://archive.softwareheritage.org/badge/origin/https://github.com/supernovae-st/nika-registry/" alt="Archived by Software Heritage"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-Apache--2.0-blue.svg" alt="Apache-2.0"></a>
</p>

## Thirty seconds, no API key

Install the engine. The npm package carries the `nika` binary for your
platform; the Homebrew formula `supernovae-st/tap/nika` installs the same one:

```sh
npm install @supernovae-st/nika@0.118.7
./node_modules/.bin/nika --version
```

```
nika 0.118.7 (f3a31a6ee)
```

Pull an entry by its coordinate. The engine fetches the bytes the entry pins,
re-hashes them against the entry's sha256, caches the file, then audits it
exactly as it audits a local file:

```sh
nika check registry:supernovae-st/meeting-actions@0.1.0
```

```
→ registry supernovae-st/meeting-actions@0.1.0 · fetched + digest verified · tier unprovenanced · unsigned entry (v0.1 digest floor) (sha256 31b0aeef8f79f245…)
  cached: ~/.nika/registry/supernovae-st/meeting-actions/0.1.0.nika.yaml — later runs use this copy, offline included
PARSE ✗  [NIKA-PARSE-005] unknown field `workflow` in the workflow envelope (strict mode) — this block shipped in the fourteen-key envelope and died with the nine-key one (2026-08-12) — the identity moved onto `nika:` itself (`nika: <id>` · a kebab-case name, no longer `v1`); its `description:` prose belongs in a `#` comment above `nika:`, never dropped · the fields here: nika · model · inputs · const · secrets · permits · run · tasks · outputs · → nika explain NIKA-PARSE-005
  --> ~/.nika/registry/supernovae-st/meeting-actions/0.1.0.nika.yaml:23:1
   |
23 | workflow:
   | ^
```

Exit code 2. The home directory is shortened to `~` above; every other byte is
the engine's.

Three lines, three facts. The first line is the registry's promise, kept by
the engine: the pinned bytes were fetched, their digest matched the entry, and
the trust tier is named (a v0.1 entry carries a digest, not yet a signature).
The second line is the cache: the next pull is offline, and a cached copy is
re-hashed on every hit (a tampered copy refuses with `NIKA-REG-004` and tells
you to delete it). The third line is the audit, and on the released engine it
is red today: every first-party entry is pinned at a spec commit older than the
current envelope, and the certifier still pins the last engine that accepted
those bytes (`ENGINE_VERSION` in `scripts/cert.py`). That is the registry
working as designed: a proof you re-run yourself can come back red. The
certifier's heal lane already records these refusals
([#30](https://github.com/supernovae-st/nika-registry/pull/30)); the fix is a
deliberate `SPEC_PIN` bump plus re-certification, never a hand edit, because a
merged entry is immutable.

The same coordinate composes. In your own workflow, `invoke.workflow` takes a
filesystem path or a pinned `registry:` coordinate, and the parent declares the
boundary the child's certificate names (`permits_boundary` in
[its cert](certs/supernovae-st/meeting-actions/0.1.0.json)):

```yaml
nika: compose-meeting-actions
permits:
  fs:
    read: ["examples/fixtures/meeting-transcript.txt"]
    write: ["out/action-items.json"]
  tools: ["nika:log", "nika:read", "nika:write"]
tasks:
  actions:
    invoke:
      workflow: "registry:supernovae-st/meeting-actions@0.1.0"
outputs:
  actions: ${{ tasks.actions.output }}
```

```sh
nika check compose.nika.yaml
```

```
      wave 1 actions (invoke · workflow:registry:supernovae-st/meeting-actions@0.1.0)
 ✔ COMPOSITION direct child calls are static, typed and contained · closure acyclic
 ✔ PERMITS  literal + const: args fit the boundary · computed paths + symlinks are the RUN's verdict
 ✔ TRIFECTA no lethal trifecta over the declared permits: without a human gate
 ✔ JOURNEY internal · 0 sources · 0 destinations · 0 model endpoints · no secret reaches an external destination
 ✔ audited · 1 task · 1 wave · permits tools:nika:log,nika:read,nika:write read:examples/fixtures/meeting-transcript.txt write:out/action-items.json · est out ≤$0.0000 · 1 distinct hint across 5 sites · risk supervised
 layers · valid ✔ · access ready ○ · capacity fit ✔ · run ready ○
```

Exit code 0. The check binds the coordinate (static, pinned, acyclic: an
unpinned or templated target refuses with `NIKA-COMP-001`) without opening the
child, so the five sites of the one hint are `NIKA-DRIFT-001` on the boundary
you declared for it. The run is a different door: on 0.118.7 the execution
snapshot captures local children only, and a registry child is refused at
admission before anything executes:

```
nika run: execution admission: registry dependency `registry:supernovae-st/meeting-actions@0.1.0` has no atomic owned-byte view
```

A file pulled into your workspace composes by path like any local child.

## Why this building

- **Audited before it runs.** The pull is `nika check`: fetch, digest, cache,
  then the same audit every local file gets (permits, effects, secrets, cost).
  Entries are data; nothing executes at install time.
- **Sovereign by default.** The artifact never leaves its publisher's
  repository; this registry holds a pointer, a digest and a proof. The cache is
  a directory on your disk that works offline, and a mirror or a fork speaks
  the same contract.
- **Re-proven after.** On every PR and every night, CI re-fetches, re-hashes,
  re-judges and re-certifies every entry. `scripts/verify.py` is the proof; it
  runs offline against a mirror, with no engine.
- **Immutable, with a ledger.** A merged entry never changes bytes; a bad
  version is yanked by an advisory, never deleted; a burned identifier is never
  reused.

## Consume

**The engine, natively.** `nika check` and `nika run` both take
`registry:owner/name[@version]`; without a version the newest one resolves and
the engine prints the resolved coordinate. The verified file lands under
`~/.nika/registry/<owner>/<name>/` as `<version>.nika.yaml` next to
`<version>.meta.json` (the pin: source repository, commit, path, sha256, trust
tier). `permits:` never govern the fetch, and a cache hit is re-hashed before
it is read:

```
→ registry supernovae-st/meeting-actions@0.1.0 · cache · digest re-verified (sha256 31b0aeef8f79f245…) · offline · tier unprovenanced · unsigned entry (v0.1 digest floor) (recorded at fetch)
```

**One auditable script, no engine needed to fetch and verify.** You cloned
the repository, so you can read every line before it runs. `get.py` resolves
the entry (an unqualified name that spans two publishers is refused), consults
the advisories before any bytes move, fetches from the publisher's repository
at the pinned commit, refuses on any mismatch (hash, advisory, overwrite),
writes the file, and audits it when an engine is present. It never executes
anything: the file lands on disk and you decide.

```sh
git clone https://github.com/supernovae-st/nika-registry && cd nika-registry
python3 scripts/get.py --list
python3 scripts/get.py meeting-actions
```

```
→ supernovae-st/meeting-actions@0.1.0
  source  supernovae-st/nika-spec @ 699ebb08585d · examples/meeting-actions.nika.yaml
  sha256  31b0aeef8f79f245… ✓ (matches the pinned digest)
  wrote   meeting-actions.nika.yaml (3831 bytes)
  cert    clean=True · exec=no · llm_calls=1 · cost unbounded (set max_tokens)
  audit   nika check · findings (exit 2)
```

`cert` is the certifier's word at its pinned engine; `audit` is your engine's
word today (the finding above). When they disagree, the audit wins: the cert is
informative, the check is the proof.

**Agents.** One fetch of [`index.json`](index.json) carries every artifact with
its pin, digest, cert summary and advisory state; [`llms.txt`](llms.txt)
teaches the consume-and-verify path in agent-readable form. Never install a
name a model suggested without resolving it here first, and never skip the
hash check.

**Badges.** Every artifact has a live cert badge:
`https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/supernovae-st/nika-registry/main/badges/<publisher>--<name>.json`

## Publish (a PR)

Your artifact stays in your git repository: the registry stores a pointer, a
digest and a proof, never a copy. Namespace equals repository ownership
(`registry/workflows/<your-github-owner>/<name>/<version>.toml`), and CI
refuses an entry whose publisher does not own the source repository.

1. Make the workflow pass `nika check` on the released engine: the nine-key
   envelope (`nika: <kebab-id>` · model · inputs · const · secrets · permits ·
   run · tasks · outputs), a declared `permits:` block, endpoints and keys
   parameterized through `inputs:`.
2. Add the entry file (copy [`ENTRY_TEMPLATE.toml`](ENTRY_TEMPLATE.toml)):
   `source.rev` is a full 40-hex commit, never a tag or a branch;
   `integrity.sha256` is `shasum -a 256` of the exact pinned bytes; the
   license is on the OSI allowlist in `scripts/verify.py`.
3. Open the PR. CI re-proves it (hash · oracle · secrets · license ·
   namespace) and a maintainer reads the prompts (`CODEOWNERS`): stored
   prompt injection is a real attack class and no oracle catches intent.
   Green CI is necessary, not sufficient.

The first-party entries (`supernovae-st/*`) are not a hand-kept list: they
are a projection of the spec's canonical pack at `SPEC_PIN`
(`scripts/project_pack.py`, gated `--check` in CI). Add a showcase to
[nika-spec](https://github.com/supernovae-st/nika-spec) and re-run the
projector; the registry cannot diverge from the pack. Community entries are
authored by PR. Full rules: [CONTRIBUTING.md](CONTRIBUTING.md).

## The re-proof

[`verify.yml`](.github/workflows/verify.yml) runs on every push to `main`,
every PR and every night. PR and push runs resolve sources offline from the
pinned oracle checkout (deterministic, and stricter on one class: a commit
that was force-pushed away vanishes from a fresh clone while a CDN may still
serve it); the nightly run keeps the real consumer path as the availability
probe, so a vanished source commit or a rewritten history turns the board red.

| Step | What it holds |
|---|---|
| Immutability gate | a merged `registry/**/*.toml` is never modified or deleted (law 1); the operator's carve-out is `advisories/OVERRIDE-<pr>.md`, itself the audit trail |
| Pin the oracle at `SPEC_PIN` | the judge is the spec commit in `SPEC_PIN`, never a floating `HEAD` |
| First-party entries match the spec pack | `scripts/project_pack.py --check` |
| Gate guards hold | `scripts/selftest.py`: the guards' own invariants (traversal, advisory targeting, semver precedence, the hand-off) |
| Re-prove every entry | `scripts/verify.py --all`: R1 immutability · R2 full-commit + full-sha256 pins · R3 fetched bytes hash to the digest · R4 the oracle re-passes the artifact · R5 no key-shaped string · R6 namespace = source ownership · R7 license floor |
| Fetch the pinned engine | the release asset named in the workflow, sha256-checked before use |
| Certs + catalog in sync | `scripts/cert.py --check`: the engine's static analysis of every pinned artifact, re-derived and byte-compared |
| Index + llms.txt + badges in sync | `scripts/index.py --check` |
| Orphan gate | `scripts/orphan_gate.py`: every cert, badge and index row cites a live entry (law 8) |
| Estate manifest observes | `scripts/estate.py --check`: every tracked file declares its provenance (observation, non-blocking) |
| Advisories parse | every advisory has its fields and names a live entry, or is a tombstone |
| `mirror` job | `scripts/estate.py` is byte-identical to nika-estate at `ESTATE_PIN` |

Replay it on your machine with a nika-spec clone checked out at `SPEC_PIN`:

```sh
export NIKA_SPEC_DIR=/path/to/nika-spec     # the oracle, at SPEC_PIN
export OFFLINE_ROOT=/path/to                # <OFFLINE_ROOT>/nika-spec resolves sources offline
python3 scripts/project_pack.py --check
python3 scripts/selftest.py
python3 scripts/verify.py --all
python3 scripts/index.py --check
python3 scripts/orphan_gate.py
python3 scripts/estate.py --check
```

```
✓ 26 first-party showcases in sync with the pack @ 0.1.0
selftest: all gate guards hold
26/26 entries re-proven
✓ index + llms.txt + badges in sync (26 artifacts)
✓ orphan gate · 26 entries · every cert, badge and index row cites a live entry
✓ estate.yaml in sync with the tracked tree
```

The certifier is the one step that needs the exact engine it pins; any other
binary is refused before a single cert is read:

```sh
NIKA_BIN=/path/to/nika python3 scripts/cert.py --check
```

```
cert.py: NIKA_BIN is `nika 0.118.7 (f3a31a6ee)` — certs pin nika 0.108.0 (bump ENGINE_VERSION deliberately, then --write)
```

## The catalog and the certificates

[`CATALOG.md`](CATALOG.md) is generated by `scripts/cert.py --write` from the
engine's static analysis of every pinned artifact at the certifier's pinned
engine: can it exec? which tools? how many model calls? what cost ceiling?
which secrets leak or egress? what `permits:` boundary does it need? Each row
links a machine certificate under [`certs/`](certs/). You never have to trust
the column: the cert re-derives locally with `nika check`, and its
`permits_boundary` is the boundary a composing parent declares.

**"clean" is not "safe".** A cert proves the effect stays inside the
workflow's *declared* permits; it cannot vet what a permitted program or tool
actually does. An **unbounded grant** (`exec: true` runs any program, a `*`
tool allows any tool) is marked **⚠** on every surface: there, "what it can
do" is effectively "anything in that category", so read the workflow before
you run it. ⚠ flags a grant to inspect, not a verdict of unsafe.

## The laws

This registry implements
[registry-v0.1](https://github.com/supernovae-st/nika-spec/blob/main/registry/registry-v0.1.md),
the normative sharing contract in the Apache-2.0 spec: anyone can run a
conformant registry (org-internal, mirror, fork) and clients speak to all of
them identically. The full law text lives in [POLICIES.md](POLICIES.md): eight
numbered laws, each with the incident that wrote it and the gate that holds it.

| Rule | Kills |
|---|---|
| Entries are **immutable**: new version = new file · withdrawal = an [advisory](advisories/), never a delete | left-pad · rug-pulls |
| **Full-commit + full-sha256 pinning**: no tags, no branches | tj-actions tag rewrite |
| CI **re-hashes the fetched bytes** | manifest confusion |
| CI **re-runs the oracle** | the class nobody else catches: broken or lying artifacts |
| **Key-shaped strings refuse the gate** | the n8n shared-template credential leak |
| **Namespace = source ownership** | dependency confusion · typosquatting |
| **Zero install-time execution**: entries and artifacts are data | event-stream · Shai-Hulud · ComfyUI |

Before running any shared workflow, read its `permits:` and `exec:` blocks.
`nika check` shows you the full effect surface (network · fs · secrets · cost)
before a single token is spent. That is the point of Nika.

## Yanking and advisories

A compromised or broken version is never deleted (reproducibility): it gets an
advisory in [`advisories/`](advisories/) (OSV-inspired TOML), which
`scripts/get.py` consults before any bytes move and CI validates on every run.
A tombstone advisory names an identifier the tree no longer holds; that
`name@version` is never reusable, by anyone.

## Keeping it fresh

[`release-heal.yml`](.github/workflows/release-heal.yml) runs daily: on a new
engine release it bumps the certifier pin and the digest-verified download in
`verify.yml`, re-derives certs, catalog, index, `llms.txt`, badges and the
estate manifest, and opens one idempotent PR. Nothing lands directly: the
verify gate re-proves the heal like any other PR.

<!-- city:map -->
## The city · where this repo sits

```text
📜 nika-spec ──── language law, conformance oracle and the canonical pack
    │
    ▼
⚙️ nika ───────── engine, admission, execution, receipts and the certifier
    │
    ▼
🏪 nika-registry ── this market: pinned coordinates, re-proven entries, certificates
    │
    ▼
🧩 your workflows · nika check registry:owner/name@version · invoke: { workflow: "registry:…" }
```

This repository holds pointers, digests and proofs. The artifacts stay in their
publisher repositories and the law stays in nika-spec; nothing authoritative is
typed here.

All the buildings: [nika-spec](https://github.com/supernovae-st/nika-spec) ·
[nika](https://github.com/supernovae-st/nika) ·
[nika.sh](https://github.com/supernovae-st/nika.sh) ·
[nika-docs](https://github.com/supernovae-st/nika-docs) ·
[nika-client](https://github.com/supernovae-st/nika-client) ·
[nika-vscode](https://github.com/supernovae-st/nika-vscode) ·
[nika-plugins](https://github.com/supernovae-st/nika-plugins) ·
[gh-nika](https://github.com/supernovae-st/gh-nika) ·
[homebrew-tap](https://github.com/supernovae-st/homebrew-tap) ·
[nika-action](https://github.com/supernovae-st/nika-action) ·
[nika-actions-starter](https://github.com/supernovae-st/nika-actions-starter) ·
[nika-registry](https://github.com/supernovae-st/nika-registry) ·
[nika-estate](https://github.com/supernovae-st/nika-estate).
<!-- /city:map -->

## License

Registry metadata: [Apache-2.0](LICENSE). Each artifact carries its own
`license` field. Security reports follow the
[organization policy](https://github.com/supernovae-st/.github/blob/main/SECURITY.md);
contributions follow [CONTRIBUTING.md](CONTRIBUTING.md); the language, the
engine and the other doors are at [docs.nika.sh](https://docs.nika.sh).
