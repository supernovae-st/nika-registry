#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2026 SuperNovae Studio <contact@supernovae.studio>
#
# engine_pin.py — move the CURRENT certifier engine to a published release.
#
# release-heal owns this move. It used to be three inline perl rewrites that
# expected the digest line of a download named `nika.tar.gz`. When verify.yml
# gained a second, frozen engine (`current.tar.gz` beside `historical.tar.gz`),
# the digest rewrite matched nothing and every heal died on "digest rewrite
# missed" — and the unanchored URL rewrite would also have moved the frozen
# historical download to the new release without its digest.
#
# Exactly three carriers move, each matched exactly once before the write:
#   scripts/cert.py               ENGINE_VERSION = "<version>"
#   .github/workflows/verify.yml  the current.tar.gz download URL
#   .github/workflows/verify.yml  the current.tar.gz sha256 line
# The historical engine (HISTORICAL_ENGINE_VERSION · historical.tar.gz) is
# never touched. A missing or duplicated carrier refuses with nothing written,
# so a layout change turns the heal red instead of silently half-moving pins.
#
# Usage:
#   python3 scripts/engine_pin.py --tag vX.Y.Z --sha256 <linux-x64 archive digest>
#   python3 scripts/engine_pin.py --print-historical   # '<url> <sha256>' of the frozen engine
#                                                      # (read-only: the heal certifies with it)

import argparse
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
CERT_PY = pathlib.Path("scripts/cert.py")
VERIFY_YML = pathlib.Path(".github/workflows/verify.yml")

TAG = re.compile(r"v(\d+\.\d+\.\d+)")
SHA256 = re.compile(r"[0-9a-f]{64}")
ENGINE_LINE = re.compile(r'^ENGINE_VERSION = "[0-9.]+"$', re.MULTILINE)
CURRENT_URL = re.compile(
    r"^(\s*curl -fsSLo current\.tar\.gz https://github\.com/supernovae-st/nika/releases/download/)"
    r"v[0-9.]+/nika-linux-x64-[0-9.]+\.tar\.gz$",
    re.MULTILINE,
)
CURRENT_SUM = re.compile(
    r'^(\s*echo ")[0-9a-f]{64}(  current\.tar\.gz" \| sha256sum -c -)$', re.MULTILINE
)
HISTORICAL_URL = re.compile(
    r"^\s*curl -fsSLo historical\.tar\.gz "
    r"(https://github\.com/supernovae-st/nika/releases/download/v[0-9.]+/nika-linux-x64-[0-9.]+\.tar\.gz)$",
    re.MULTILINE,
)
HISTORICAL_SUM = re.compile(
    r'^\s*echo "([0-9a-f]{64})  historical\.tar\.gz" \| sha256sum -c -$', re.MULTILINE
)


class PinError(ValueError):
    """A carrier is missing, duplicated or malformed: nothing is written."""


def _once(pattern: re.Pattern, text: str, replace, carrier: str) -> str:
    updated, count = pattern.subn(replace, text)
    if count != 1:
        raise PinError(f"{carrier}: expected exactly one match, found {count}")
    return updated


def rewrite(cert_text: str, verify_text: str, tag: str, sha256: str) -> tuple[str, str]:
    """Return (cert.py, verify.yml) with the current engine moved to `tag`."""
    match = TAG.fullmatch(tag)
    if not match:
        raise PinError(f"not a stable release tag: {tag!r}")
    if not SHA256.fullmatch(sha256):
        raise PinError(f"not a lowercase sha256 digest: {sha256!r}")
    version = match.group(1)
    cert_text = _once(ENGINE_LINE, cert_text, f'ENGINE_VERSION = "{version}"',
                      "scripts/cert.py ENGINE_VERSION")
    verify_text = _once(CURRENT_URL, verify_text,
                        lambda m: f"{m.group(1)}{tag}/nika-linux-x64-{version}.tar.gz",
                        "verify.yml current.tar.gz download")
    verify_text = _once(CURRENT_SUM, verify_text,
                        lambda m: f"{m.group(1)}{sha256}{m.group(2)}",
                        "verify.yml current.tar.gz digest")
    return cert_text, verify_text


def historical(verify_text: str) -> tuple[str, str]:
    """The frozen engine's download URL and digest, as verify.yml pins them (read-only)."""
    urls, sums = HISTORICAL_URL.findall(verify_text), HISTORICAL_SUM.findall(verify_text)
    if len(urls) != 1 or len(sums) != 1:
        raise PinError(f"verify.yml historical.tar.gz: expected one download and one digest, "
                       f"found {len(urls)} and {len(sums)}")
    return urls[0], sums[0]


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--tag", help="the published engine release, e.g. v0.120.3")
    parser.add_argument("--sha256", help="that release's nika-linux-x64 archive digest")
    parser.add_argument("--print-historical", action="store_true",
                        help="print the frozen engine's '<url> <sha256>' from verify.yml and exit")
    parser.add_argument("--root", type=pathlib.Path, default=ROOT, help=argparse.SUPPRESS)
    args = parser.parse_args(argv)
    cert_path, verify_path = args.root / CERT_PY, args.root / VERIFY_YML
    if args.print_historical:
        try:
            print(" ".join(historical(verify_path.read_text())))
        except PinError as error:
            print(f"engine_pin: {error}", file=sys.stderr)
            return 1
        return 0
    if not (args.tag and args.sha256):
        parser.error("--tag and --sha256 are required unless --print-historical")
    cert_text, verify_text = cert_path.read_text(), verify_path.read_text()
    try:
        new_cert, new_verify = rewrite(cert_text, verify_text, args.tag, args.sha256)
    except PinError as error:
        print(f"engine_pin: {error} · nothing written", file=sys.stderr)
        return 1
    if (new_cert, new_verify) == (cert_text, verify_text):
        print(f"engine_pin: current engine already {args.tag}")
        return 0
    cert_path.write_text(new_cert)
    verify_path.write_text(new_verify)
    print(f"engine_pin: current engine → {args.tag} (historical engine unchanged)")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
