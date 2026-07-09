# AGENTS.md — nika-registry (the verifiable workflow registry)

Vendor-neutral agent entry per the AGENTS.md convention (agents.md).

## What this repo is

The public registry of Nika workflows — every entry pinned to a full
commit + sha256 and **re-proven by CI** (the spec's conformance oracle
+ the engine's own static certificate). Entries are **immutable**: a
new version is a new file; withdrawal is an [advisory](advisories/),
never a delete.

## The ONE law — a pin bump projects THREE stages

`SPEC_PIN` bumps are a reviewed, deliberate act (its header documents
the procedure). The bump reprojects **three owned stages — run all
three, then check all four, BEFORE pushing** (each stage missed here
is a red CI round, empirically proven 2026-07-09):

```sh
export NIKA_SPEC_DIR=/path/to/nika-spec   # a clone containing SPEC_PIN's commit
export NIKA_BIN=/path/to/nika             # the PINNED release asset — see below

python3 scripts/project_pack.py --write   # 1 · the entry TOMLs
python3 scripts/cert.py --write           # 2 · certs + CATALOG.md
python3 scripts/index.py --write          # 3 · index.json · llms.txt · badges

# the full verify suite (what CI runs):
python3 scripts/project_pack.py --check
python3 scripts/cert.py --check
python3 scripts/index.py --check
python3 scripts/selftest.py
```

## Load-bearing facts (verify in-repo · never from memory)

- **`cert.py` pins its engine version** (`ENGINE_VERSION` in the
  script) and REFUSES any other binary — download the exact release
  asset (digest-verified, as CI does), never certify with a dev build.
- The current draft version is a **rolling projection** (`--write`
  re-renders it); **older versions stay frozen** — the projector never
  touches them.
- The registry pins the **real downloaded bytes** (banner included) —
  NOT the spec manifest's `sha256_16`, which hashes the lean display
  text. Two legitimate contracts; the registry's is the install one.
- Never hand-edit a merged entry, a cert, `CATALOG.md`, `index.json`,
  `llms.txt` or a badge — all six are projections.

## Verify before any PR

Run the four `--check`s above. CI (`.github/workflows/verify.yml`)
re-proves everything with the pinned engine and fails on any drift.
