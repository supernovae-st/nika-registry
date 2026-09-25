"""release-heal never rewrites a branch: one branch per release, reuse or recover on retry."""
import contextlib
import io
import json
import pathlib
import subprocess
import sys
import tempfile
import unittest

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import heal_branch

ROOT = pathlib.Path(__file__).resolve().parent.parent
HEAL = ROOT / ".github/workflows/release-heal.yml"
BRANCH = "bot/certifier-heal-v9.9.9"


def git(cwd, *args, check=True):
    return subprocess.run(["git", "-c", "user.name=heal-test", "-c", "user.email=heal@test",
                           "-c", "init.defaultBranch=main", "-c", "commit.gpgsign=false", *args],
                          cwd=cwd, capture_output=True, text=True, check=check)


class HealBranch(unittest.TestCase):
    def test_one_branch_per_release(self):
        self.assertEqual(heal_branch.branch_for("v0.120.3"), "bot/certifier-heal-v0.120.3")
        for tag in ("0.120.3", "v0.120", "v0.121.0-rc.1", "v1.2.3;x", "v1.2.3\n", "main"):
            with self.assertRaises(ValueError):
                heal_branch.branch_for(tag)

    def test_what_already_exists_decides_the_run(self):
        cases = [
            (False, [], "create"),
            (False, [{"number": 7, "state": "CLOSED"}], "create"),  # branch deleted: start again
            (True, [], "recover"),                                    # pushed, PR never opened
            (True, [{"number": 9, "state": "OPEN"}], "reuse 9"),
            (True, [{"number": 4, "state": "CLOSED"}, {"number": 9, "state": "OPEN"}], "reuse 9"),
        ]
        for exists, prs, want in cases:
            self.assertEqual(heal_branch.decide(exists, prs), want, (exists, prs))

    def test_a_closed_or_merged_branch_is_refused_not_papered_over(self):
        for prs, needle in (([{"number": 4, "state": "CLOSED"}], "#4 .*closed"),
                            ([{"number": 5, "state": "MERGED"}], "#5 .*merged")):
            with self.assertRaisesRegex(heal_branch.HealRefusal, needle):
                heal_branch.decide(True, prs)

    def test_malformed_pr_records_are_errors(self):
        for prs in ([{"number": "1", "state": "OPEN"}], [{"number": 1, "state": "DRAFT"}], ["x"]):
            with self.assertRaises(ValueError):
                heal_branch.decide(True, prs)

    def test_cli_exit_codes(self):
        def run(*argv):
            out, err = io.StringIO(), io.StringIO()
            with contextlib.redirect_stdout(out), contextlib.redirect_stderr(err):
                code = heal_branch.main(list(argv))
            return code, out.getvalue().strip(), err.getvalue()

        self.assertEqual(run("branch", "v0.120.3")[:2], (0, "bot/certifier-heal-v0.120.3"))
        self.assertEqual(run("decide", "--exists", "1", "--prs", "[]")[:2], (0, "recover"))
        self.assertEqual(run("decide", "--exists", "0", "--prs", "[]")[:2], (0, "create"))
        closed = json.dumps([{"number": 3, "state": "CLOSED"}])
        code, out, err = run("decide", "--exists", "1", "--prs", closed)
        self.assertEqual((code, out), (1, ""))
        self.assertIn("refused", err)
        self.assertEqual(run("decide", "--exists", "1", "--prs", "{")[0], 2)
        self.assertEqual(run("decide", "--exists", "1", "--prs", "{}")[0], 2)
        self.assertEqual(run("branch", "main")[0], 2)

    def test_a_normal_push_never_overwrites_an_existing_branch(self):
        """The heal's exact existence probe and push shape, against a local bare remote."""
        with tempfile.TemporaryDirectory() as tmp:
            tmp = pathlib.Path(tmp)
            remote = tmp / "origin.git"
            git(tmp, "init", "--bare", str(remote))
            probe = ["ls-remote", "--exit-code", "--heads", str(remote), f"refs/heads/{BRANCH}"]
            self.assertEqual(git(tmp, *probe, check=False).returncode, 2, "absent branch probes as 2")
            first = tmp / "first"
            git(tmp, "clone", "-q", str(remote), str(first))
            (first / "certs.txt").write_text("first run\n")
            git(first, "add", "-A")
            git(first, "commit", "-q", "-m", "first heal")
            git(first, "push", "-q", "origin", f"HEAD:refs/heads/{BRANCH}")
            pushed = git(tmp, *probe).stdout.split()[0]
            self.assertEqual(git(tmp, *probe, check=False).returncode, 0, "present branch probes as 0")

            retry = tmp / "retry"
            git(tmp, "clone", "-q", str(remote), str(retry))
            (retry / "certs.txt").write_text("a later, different run\n")
            git(retry, "add", "-A")
            git(retry, "commit", "-q", "-m", "second heal")
            refused = git(retry, "push", "-q", "origin", f"HEAD:refs/heads/{BRANCH}", check=False)
            self.assertNotEqual(refused.returncode, 0, "a normal push must not overwrite the branch")
            self.assertEqual(git(tmp, *probe).stdout.split()[0], pushed, "remote branch unchanged")

    def test_the_heal_never_forces_and_decides_before_deriving(self):
        heal = HEAL.read_text()
        for forbidden in ("push -f", "--force", "checkout -B", "+refs/", "2>/dev/null || echo"):
            self.assertNotIn(forbidden, heal)
        self.assertIn('git push origin "HEAD:refs/heads/${branch}"', heal)
        decided = heal.index("scripts/heal_branch.py decide")
        self.assertLess(decided, heal.index("scripts/engine_pin.py --tag"))
        self.assertLess(decided, heal.index("scripts/cert.py --write"))
        self.assertIn('NIKA_HISTORICAL_BIN="$RUNNER_TEMP/historical/nika"', heal)
        self.assertLess(heal.index("git add -A"), heal.index("scripts/estate.py --write"))


if __name__ == "__main__":
    unittest.main()
