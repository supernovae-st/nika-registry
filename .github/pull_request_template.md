## New entry checklist

- [ ] `nika check` passes on the artifact (or `conformance/runner.py validate`)
- [ ] Entry at `registry/<type>s/<MY-github-owner>/<name>/<version>.toml`
- [ ] `source.rev` is a **full 40-hex commit** (never a tag or branch)
- [ ] `integrity.sha256` = `shasum -a 256` of the exact pinned bytes
- [ ] No real endpoints, keys or personal data — parameterized via `vars:`
- [ ] I am not editing an already-merged entry (immutable — new version = new file)

CI re-proves everything above; a maintainer reads the prompts (intent
review — no oracle catches a malicious instruction). Both must pass.
