# Contributing

**Submit**: PR adding `registry/<type>s/<your-github-owner>/<name>/<version>.toml`.
CI re-proves it; a maintainer merges. Green CI is necessary, not sufficient —
we read the artifact (prompts included: stored prompt-injection is a real
attack class, and no oracle catches intent).

**Never**:
- edit a merged entry (immutable — publish a new version)
- point `source.rev` at a tag or branch (full commit only)
- commit an artifact copy here (the registry stores pointers + proofs)
- share a workflow with real endpoints/keys — parameterize via `vars:`

**First-party entries** (`supernovae-st/*`) are generated from the spec
pack by `scripts/project_pack.py` — do not hand-edit them; add the
showcase to nika-spec instead. This only applies to our own namespace;
your entries under `<your-owner>/` are yours to author.

**Withdrawal**: PR an advisory (see `advisories/README.md`).

## Signatures (reserved · v0.2)

Entries will carry an optional `[signature]` block — authorship proof,
sovereign-first (minisign/Ed25519 · the key stays yours · the `.minisig`
sidecar lives in YOUR source repo, never here):

```toml
[signature]
scheme = "minisign"
pubkey = "RW..."                    # the publisher's public key
sig = "<path>.minisig"              # sidecar next to the artifact, in the source repo
```

Integrity is already covered without it (full-commit + sha256 + CI
re-proof); signatures add authorship across index forks and mirrors.
The field lands with `nika sign` engine-side — do not hand-roll it.
