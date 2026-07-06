# Advisories

Withdrawal surface — entries are immutable, so a bad version is *yanked* by
advisory, never deleted. One TOML per advisory, OSV-inspired:

```toml
id = "NIKA-ADV-2026-0001"
published = "2026-07-06"
severity = "high"            # low · medium · high · critical
affected = "workflows/<publisher>/<name>"
versions = ["0.1.0"]
summary = "One line: what is wrong."
details = "What happened · how it was found · what a consumer should do."
action = "upgrade to 0.1.1"  # or: "do not run · no fix"
```

CI validates advisory files parse and reference existing entries.
