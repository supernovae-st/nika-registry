"""Historical certificates are re-proven, never rewritten by a new release."""
import contextlib
import copy
import io
import json
import os
import pathlib
import subprocess
import sys
import tempfile
import tomllib
import unittest
from unittest.mock import patch

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import cert

ROOT = cert.ROOT
ENTRY = pathlib.Path("registry/workflows/supernovae-st/meeting-actions/0.1.0.toml")
CERT = pathlib.Path("certs/supernovae-st/meeting-actions/0.1.0.json")


class CertificateHistory(unittest.TestCase):
    def test_only_exact_frozen_bytes_select_historical_engine(self):
        raw = (ROOT / ENTRY).read_bytes()
        entry = tomllib.loads(raw.decode())
        self.assertEqual(cert.entry_engine(entry, raw)[0], "NIKA_HISTORICAL_BIN")
        self.assertEqual(cert.entry_engine(entry, raw + b"\n")[0], "NIKA_BIN")
        for key, value in (("version", "0.2.0"), ("name", "other"), ("publisher", "other")):
            changed = copy.deepcopy(entry)
            changed[key] = value
            self.assertEqual(cert.entry_engine(changed, raw)[0], "NIKA_BIN")
        for key in ("repo", "rev", "path"):
            changed = copy.deepcopy(entry)
            changed["source"][key] = "other"
            self.assertEqual(cert.entry_engine(changed, raw)[0], "NIKA_BIN")

    def test_binary_identity_is_exact_and_released(self):
        for banner in ("nika 0.120.0-dev (f6155d1be)", "nika 0.120.0 (f6155d1be-dirty)",
                       "nika 0.120.01 (f6155d1be)", "nika 0.119.0 (f6155d1be)"):
            with self.subTest(banner=banner), patch.object(cert.subprocess, "run",
                    return_value=subprocess.CompletedProcess([], 0, banner, "")):
                with self.assertRaises(ValueError):
                    cert.require_engine("nika", "0.120.0")

    def test_all_current_and_historical_entries_are_selected(self):
        entries = list(cert.load_entries())
        self.assertEqual(len(entries), 53)
        judges = [cert.entry_engine(e, (ROOT / p).read_bytes())[0] for p, e in entries]
        self.assertEqual(judges.count("NIKA_HISTORICAL_BIN"), 26)
        self.assertEqual(judges.count("NIKA_BIN"), 27)

    def test_write_reproves_frozen_cert_and_refuses_drift_without_repairing(self):
        original = (ROOT / CERT).read_bytes()
        document = json.loads(original)
        raw = (ROOT / ENTRY).read_bytes()
        entry = tomllib.loads(raw.decode())
        for corrupt in (False, True):
            with self.subTest(corrupt=corrupt), tempfile.TemporaryDirectory() as directory:
                root = pathlib.Path(directory)
                (root / ENTRY).parent.mkdir(parents=True)
                (root / ENTRY).write_bytes(raw)
                (root / CERT).parent.mkdir(parents=True)
                saved = original + (b"\n" if corrupt else b"")
                (root / CERT).write_bytes(saved)
                # Source digest verification is separate from the write boundary.
                body = b"pinned source fixture"
                real_hash = cert.hashlib.sha256
                def digest(data):
                    if data == body:
                        class SourceDigest:
                            def hexdigest(self):
                                return entry["integrity"]["sha256"]
                        return SourceDigest()
                    return real_hash(data)
                with patch.object(cert, "ROOT", root), patch.object(cert, "require_engine"), \
                     patch.object(cert, "fetch_source", return_value=body), \
                     patch.object(cert.hashlib, "sha256", side_effect=digest), \
                     patch.object(cert, "engine_cert", return_value=document["certificate"]) as judge, \
                     patch.dict(os.environ, {"NIKA_BIN": "current", "NIKA_HISTORICAL_BIN": "historical"}), \
                     patch.object(sys, "argv", ["cert.py", "--write"]), \
                     contextlib.redirect_stdout(io.StringIO()), contextlib.redirect_stderr(io.StringIO()):
                    self.assertEqual(cert.main(), 1 if corrupt else 0)
                    self.assertEqual(judge.call_count, 1)
                    self.assertEqual(judge.call_args.args[0], "historical")
                self.assertEqual((root / CERT).read_bytes(), saved)


if __name__ == "__main__":
    unittest.main()
