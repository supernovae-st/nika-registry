# nika-registry

**Share Nika artifacts — workflows · packs · skills · agents — where every
entry is machine-re-proven, not gatekeeper-trusted.**

Every marketplace answers "is this safe?" with stars, downloads or moderators.
This registry answers with a **proof you re-run yourself**: each entry pins
its source to a full commit + a full sha256, and CI re-fetches the bytes,
re-hashes them, and re-runs the [conformance oracle](https://github.com/supernovae-st/nika-spec)
on every PR and every night. The `[cert]` block in an entry is informative —
**the proof is `scripts/verify.py`, and you can run it offline against a
mirror.** Trust lives in the artifact, not in this repo.

## Install (today · manual — `nika add` is on the engine roadmap)

```sh
# 1 · read the entry: source repo + pinned commit + sha256
cat registry/workflows/supernovae-st/meeting-actions/0.1.0.toml
# 2 · fetch the pinned bytes
curl -LO https://raw.githubusercontent.com/supernovae-st/nika-spec/<rev>/<path>
# 3 · verify — never skip
shasum -a 256 t1-meeting-actions.nika.yaml     # must equal integrity.sha256
nika check t1-meeting-actions.nika.yaml        # the oracle, locally
nika run t1-meeting-actions.nika.yaml
```

## Publish (a PR)

Your artifact stays in **your** git repo — the registry stores a pointer,
a digest and a proof, never a copy. Namespace = repo ownership (the Go
model): `registry/workflows/<your-github-owner>/<name>/<version>.toml`,
and CI refuses an entry whose publisher does not own the source repo.

1. Make your workflow pass `nika check` (or `conformance/runner.py validate`).
2. Add the entry file (see any seed entry for the shape).
3. Open a PR — CI re-proves it (hash · oracle · secrets · license · namespace).

## The rules (each maps to a documented registry death)

| Rule | Kills |
|---|---|
| Entries are **immutable** — new version = new file · withdrawal = an [advisory](advisories/), never a delete | left-pad · rug-pulls |
| **Full-commit + full-sha256 pinning** — no tags, no branches | tj-actions tag rewrite |
| CI **re-hashes the fetched bytes** | manifest confusion |
| CI **re-runs the oracle** | the class nobody else catches: broken/lying artifacts |
| **Key-shaped strings refuse the gate** | the n8n shared-template credential leak |
| **Namespace = source ownership** | dependency confusion · typosquatting |
| **Zero install-time execution** — entries and artifacts are data | event-stream · Shai-Hulud · ComfyUI |

Before running ANY shared workflow, read its `permits:` and `exec:` blocks —
`nika check` shows you the full effect surface (network · fs · secrets · cost)
**before a single token is spent**. That is the point of Nika.

## Yanking · advisories

A compromised or broken version is **never deleted** (reproducibility) — it
gets an advisory in [`advisories/`](advisories/) (OSV-inspired), which
consumers and future `nika add` check at install time.

## License

Registry metadata: Apache-2.0. Each artifact carries its own `license` field.
