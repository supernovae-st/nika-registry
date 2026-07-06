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

**Withdrawal**: PR an advisory (see `advisories/README.md`).
