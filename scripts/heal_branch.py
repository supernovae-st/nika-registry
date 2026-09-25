#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2026 SuperNovae Studio <contact@supernovae.studio>
#
# heal_branch.py — release-heal's branch and PR bookkeeping, without rewriting history.
#
# The heal used to `git checkout -B bot/certifier-heal` and `git push -f`: every run
# rewrote one shared branch, and any review on it. Now each engine release gets its own
# branch, bot/certifier-heal-<tag>, created once and pushed WITHOUT force. What a run
# does is decided from what already exists on the remote, BEFORE any derivation:
#
#   branch absent                      → create   derive, commit, push (never forced), open the PR
#   branch present · an open PR        → reuse    nothing pushed, nothing rewritten
#   branch present · no PR at all      → recover  open the PR for the branch already pushed
#   branch present · only closed PRs   → refuse   a human closed it: reopen it, or delete the
#                                                 branch so the next run creates it again
#   branch present · a merged PR       → refuse   merged, yet main still lacks the pin: inspect
#
# A normal push onto a branch that appeared meanwhile is refused by git itself; the next run
# then reuses or recovers. The legacy unversioned bot/certifier-heal branch is never touched.
#
# Usage (release-heal.yml):
#   python3 scripts/heal_branch.py branch v0.120.3
#   python3 scripts/heal_branch.py decide --exists 0|1 --prs '<gh pr list --json number,state>'

import argparse
import json
import re
import sys

PREFIX = "bot/certifier-heal-"
TAG = re.compile(r"v\d+\.\d+\.\d+")


class HealRefusal(ValueError):
    """The branch exists in a state a bot must not paper over."""


def branch_for(tag: str) -> str:
    if not TAG.fullmatch(tag):
        raise ValueError(f"not a stable release tag: {tag!r}")
    return PREFIX + tag


def decide(exists: bool, prs: list) -> str:
    """One of `create`, `reuse <n>`, `recover`; a HealRefusal for a closed or merged branch."""
    states = []
    for pr in prs:
        if not (isinstance(pr, dict) and isinstance(pr.get("number"), int)
                and pr.get("state") in ("OPEN", "CLOSED", "MERGED")):
            raise ValueError(f"unexpected PR record: {pr!r}")
        states.append((pr["state"], pr["number"]))
    if not exists:
        return "create"
    open_prs = sorted(n for s, n in states if s == "OPEN")
    if open_prs:
        return f"reuse {open_prs[-1]}"
    if not states:
        return "recover"
    merged = sorted(n for s, n in states if s == "MERGED")
    if merged:
        raise HealRefusal(f"PR #{merged[-1]} for this release was merged, yet main still lacks the "
                          "pin · inspect main before healing again")
    closed = sorted(n for s, n in states if s == "CLOSED")
    raise HealRefusal(f"PR #{closed[-1]} for this release was closed without merge · reopen it, or "
                      "delete the branch so the next run creates it again")


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description="release-heal branch bookkeeping")
    sub = parser.add_subparsers(dest="command", required=True)
    b = sub.add_parser("branch")
    b.add_argument("tag")
    d = sub.add_parser("decide")
    d.add_argument("--exists", choices=("0", "1"), required=True)
    d.add_argument("--prs", required=True, help="JSON from `gh pr list --json number,state`")
    args = parser.parse_args(argv)
    try:
        if args.command == "branch":
            print(branch_for(args.tag))
            return 0
        prs = json.loads(args.prs)
        if not isinstance(prs, list):
            raise ValueError("--prs is not a JSON list")
        print(decide(args.exists == "1", prs))
        return 0
    except HealRefusal as refusal:
        print(f"heal_branch: refused · {refusal}", file=sys.stderr)
        return 1
    except ValueError as error:
        print(f"heal_branch: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
