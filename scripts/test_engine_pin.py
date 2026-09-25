"""The release-heal pin move follows the live verify.yml layout, or refuses."""
import contextlib
import io
import pathlib
import shutil
import sys
import tempfile
import unittest

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import engine_pin

ROOT = engine_pin.ROOT
TAG, SHA = "v9.9.9", "a" * 64


def historical_lines(text: str) -> list[str]:
    return [line for line in text.splitlines()
            if "historical" in line or line.startswith("HISTORICAL_ENGINE_VERSION")]


class EnginePin(unittest.TestCase):
    def setUp(self):
        self.cert = (ROOT / engine_pin.CERT_PY).read_text()
        self.verify = (ROOT / engine_pin.VERIFY_YML).read_text()

    def test_moves_exactly_the_current_engine_of_the_live_files(self):
        cert, verify = engine_pin.rewrite(self.cert, self.verify, TAG, SHA)
        self.assertIn('ENGINE_VERSION = "9.9.9"', cert)
        self.assertIn("download/v9.9.9/nika-linux-x64-9.9.9.tar.gz", verify)
        self.assertIn(f'echo "{SHA}  current.tar.gz" | sha256sum -c -', verify)
        changed = [pair for pair in zip(self.cert.splitlines() + self.verify.splitlines(),
                                        cert.splitlines() + verify.splitlines())
                   if pair[0] != pair[1]]
        self.assertEqual(len(changed), 3, changed)
        self.assertEqual(historical_lines(cert), historical_lines(self.cert))
        self.assertEqual(historical_lines(verify), historical_lines(self.verify))
        self.assertTrue(historical_lines(self.verify), "the frozen engine lane vanished")

    def test_a_second_run_is_a_no_op(self):
        once = engine_pin.rewrite(self.cert, self.verify, TAG, SHA)
        self.assertEqual(engine_pin.rewrite(*once, TAG, SHA), once)

    def test_the_single_engine_layout_the_old_heal_expected_is_refused(self):
        legacy = self.verify.replace("current.tar.gz", "nika.tar.gz")
        with self.assertRaisesRegex(engine_pin.PinError, "current.tar.gz download"):
            engine_pin.rewrite(self.cert, legacy, TAG, SHA)

    def test_a_missing_or_duplicated_digest_line_is_refused(self):
        line = next(l for l in self.verify.splitlines() if "current.tar.gz\" | sha256sum" in l)
        for broken in (self.verify.replace(line + "\n", ""),
                       self.verify.replace(line, line + "\n" + line)):
            with self.assertRaisesRegex(engine_pin.PinError, "current.tar.gz digest"):
                engine_pin.rewrite(self.cert, broken, TAG, SHA)

    def test_only_stable_tags_and_lowercase_digests_are_accepted(self):
        for tag in ("0.120.3", "v0.120", "v0.121.0-rc.1", "v0.120.3 "):
            with self.assertRaises(engine_pin.PinError):
                engine_pin.rewrite(self.cert, self.verify, tag, SHA)
        for sha in ("A" * 64, "a" * 63, "g" * 64):
            with self.assertRaises(engine_pin.PinError):
                engine_pin.rewrite(self.cert, self.verify, TAG, sha)

    def test_the_command_writes_both_files_or_nothing(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = pathlib.Path(tmp)
            for rel in (engine_pin.CERT_PY, engine_pin.VERIFY_YML):
                (root / rel).parent.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(ROOT / rel, root / rel)
            broken = self.verify.replace("current.tar.gz\" | sha256sum", "other.tar.gz\" | sha256sum")
            (root / engine_pin.VERIFY_YML).write_text(broken)
            with contextlib.redirect_stderr(io.StringIO()):
                self.assertEqual(engine_pin.main(["--tag", TAG, "--sha256", SHA, "--root", tmp]), 1)
            self.assertEqual((root / engine_pin.CERT_PY).read_text(), self.cert)
            self.assertEqual((root / engine_pin.VERIFY_YML).read_text(), broken)

            (root / engine_pin.VERIFY_YML).write_text(self.verify)
            with contextlib.redirect_stdout(io.StringIO()):
                self.assertEqual(engine_pin.main(["--tag", TAG, "--sha256", SHA, "--root", tmp]), 0)
            self.assertIn('ENGINE_VERSION = "9.9.9"', (root / engine_pin.CERT_PY).read_text())
            self.assertIn(SHA, (root / engine_pin.VERIFY_YML).read_text())

    def test_the_heal_reads_the_frozen_engine_it_certifies_with(self):
        url, sha = engine_pin.historical(self.verify)
        self.assertRegex(url, r"^https://github\.com/supernovae-st/nika/releases/download/"
                              r"v[0-9.]+/nika-linux-x64-[0-9.]+\.tar\.gz$")
        self.assertRegex(sha, r"^[0-9a-f]{64}$")
        moved = engine_pin.rewrite(self.cert, self.verify, TAG, SHA)[1]
        self.assertEqual(engine_pin.historical(moved), (url, sha), "moving current moved historical")
        with self.assertRaisesRegex(engine_pin.PinError, "historical.tar.gz"):
            engine_pin.historical(self.verify.replace("historical.tar.gz", "old.tar.gz"))
        out = io.StringIO()
        with contextlib.redirect_stdout(out):
            self.assertEqual(engine_pin.main(["--print-historical"]), 0)
        self.assertEqual(out.getvalue().split(), [url, sha])

    def test_release_heal_moves_the_pin_through_this_script(self):
        heal = (ROOT / ".github/workflows/release-heal.yml").read_text()
        self.assertIn('python3 scripts/engine_pin.py --tag "${tag}" --sha256 "${sha}"', heal)
        self.assertNotIn("perl -pi", heal)


if __name__ == "__main__":
    unittest.main()
