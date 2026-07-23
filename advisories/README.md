# Advisories

Withdrawal surface — entries are immutable, so a bad version is *yanked* by
advisory, never deleted. One TOML per advisory, OSV-inspired:

```toml
id = "NIKA-ADV-2026-000N"
published = "2026-07-06"
severity = "high"            # low · medium · high · critical
affected = "workflows/<publisher>/<name>"
versions = ["0.1.0"]
summary = "One line: what is wrong."
details = "What happened · how it was found · what a consumer should do."
action = "upgrade to 0.1.1"  # or: "do not run · no fix"
```

CI validates advisory files parse and reference existing entries.

One optional field: `tombstone = true` marks an advisory whose entry is
ABSENT from the tree (deleted pre-policy, or operator-removed for
malware/legal). A tombstone row is the **burned-identifier ledger**
(POLICIES.md law 3): the named `name@version` is never reusable, by
anyone, forever. Only tombstone advisories may reference an absent
entry — everything else must cite a live one.
