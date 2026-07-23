# The laws

Normative registry policy. Each law is numbered, carries its WHY in one
line, and maps to a gate where a machine can hold it (see the enforcement
map below) · where a machine cannot, the maintainer holds it at review.
The laws bind everyone identically — including our own projector and our
own bots. First-party gets no carve-out.

## 1 · Immutability

We do not remove or modify entries once they are publicly available.
A merged `registry/<type>s/<publisher>/<name>/<version>.toml` never
changes bytes · fixes ship as a new version, in a new file.

**Why** · left-pad (npm, 2016): eleven lines unpublished, half the
ecosystem red in minutes. A registry that can un-happen a version
cannot be built on.

## 2 · The three states

An entry is **LIVE**, **YANKED**, or **ADVISORY-WITHDRAWN** · never
deleted. Yank excludes a version from NEW resolution, keeps existing
pins resolvable, records its reason in an [advisory](advisories/), and
is reversible. Withdrawal is an advisory tombstone: the entry row stays,
the artifact stays at its publisher. Deletion is reserved to the
operator for malware/legal · and even then the `name@version` + sha256
tombstone remain in `advisories/`.

**Why** · the colors.js/faker sabotage class: consumers with pins must
keep resolving while new installs are steered away. Reproducibility is
not negotiable; visibility of the steering is not either.

## 3 · Burned identifiers

A removed or withdrawn `name@version` is never reusable · by anyone,
forever. The `advisories/` ledger (`tombstone = true` rows) is the
permanent record the gate reads.

**Why** · the left-pad republish window: npm let the freed name be
re-claimed minutes after unpublish. A freed identifier is an
impersonation slot.

## 4 · Names

First-come-first-served within your GitHub-owner namespace
(`registry/<type>s/<your-owner>/` · CI refuses an entry whose publisher
does not own the source repo). Names compare **normalized**
(PEP503-style: case-fold · collapse `-_.` runs) · a new entry whose
normalized name collides with an existing one is refused. A short
reserved list (`nika` · `nika-*` · the engine's tool namespaces)
refuses at the gate. An entry existing only to reserve a name, without
genuine function, violates policy and is removed. Transfers happen via
documented dispute only · never on demand.

**Why** · dependency confusion (Birsan, 2021) + the squat economy:
ownership-anchored namespaces and normalized comparison close the
lookalike space a resolver can be tricked with.

## 5 · Typosquat screen

Publish-time edit-distance check against every existing name:
distance 1 blocks · near misses warn the reviewer, who reads the entry
knowing what it is near.

**Why** · crossenv (npm, 2017) and postmark-mcp (2025): one character
or one impersonated brand is all a squatter needs. The reviewer sees
the distance before the merge.

## 6 · No entry is executable

Entries are pointers + proofs · DATA. No install hooks, no postinstall,
no setup scripts, no code evaluated at add time. Anything that would
execute at install time is refused by class, not by review.

**Why** · event-stream · Shai-Hulud · ComfyUI: install-time execution
is the worm's front door. `nika run` after `nika check` is the ONLY
execution path, and it is the consumer's deliberate act.

## 7 · The scale ladder is written, not climbed

Monolithic `index.json` → sharded index → sparse-HTTP → CDN. We climb
a rung when its trigger fires, never before:

| Rung | Trigger |
|---|---|
| shard the index | `index.json` > 1 MB, or > 500 artifacts |
| sparse-HTTP | clients demonstrably fetch a shard subset, or > 5 000 artifacts |
| CDN | raw.githubusercontent availability or latency measurably hurts consumers |

**Why** · crates.io walked this exact ladder (git index → sparse HTTP)
under real load. Writing it now costs a paragraph; improvising it
under load costs an outage.

## 8 · The projector never deletes

A renamed or dropped spec showcase does NOT prune its entry · it yanks
it with an advisory tombstone and adds the new name. First-party
projections obey the same immutability as everyone else · the projector
gets no carve-out.

**Why** · the code-review ghost ([#21](https://github.com/supernovae-st/nika-registry/issues/21)):
`project_pack.py` pruned a renamed showcase silently, stranding its
cert + badge as orphans no drift gate could see · law 1 violated by our
own tooling, caught only by the estate observation, 16 days later.

## Enforcement map

| Law | Held by |
|---|---|
| 1 · immutability | `verify.yml` immutability gate (PR diff vs base · operator override = `advisories/OVERRIDE-<pr>.md`) |
| 2 · three states | `advisories/` format + `get.py` (yanked refuses before bytes move) |
| 3 · burned identifiers | `advisories/` tombstone rows · maintainer review on re-use attempts |
| 4 · names | `verify.py` R6 (namespace = source ownership) · normalization + reserved list at review until the gate ships |
| 5 · typosquat screen | maintainer review (edit-distance gate: planned) |
| 6 · data, never executable | the entry format has no executable field · `verify.py` + oracle refuse foreign shapes |
| 7 · scale ladder | README triggers · climbed by operator decision only |
| 8 · projector never deletes | `scripts/orphan_gate.py` in `verify.yml` (every projection cites a live entry) |

A gate marked "planned" or "review" is still law · the gate is how it
stops depending on memory.
