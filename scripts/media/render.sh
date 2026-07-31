#!/usr/bin/env bash
# render.sh — render a registry tape against the released binary and the
# LIVE registry. Sibling of the engine's render-tape.sh · same honesty
# contract: the cache is cleared so the fetch and digest-verify are real.
# Usage: bash scripts/media/render.sh [tape-name]
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
NAME="${1:-audited-artifact}"
TAPE="$ROOT/scripts/media/$NAME.tape"
[ -f "$TAPE" ] || { echo "no tape at $TAPE" >&2; exit 1; }
command -v vhs >/dev/null || { echo "vhs not installed (brew install vhs)" >&2; exit 1; }
command -v nika >/dev/null || { echo "nika not on PATH" >&2; exit 1; }

rm -rf /tmp/registry-demo "$HOME/.nika/registry/supernovae-st/release-radar"
mkdir -p /tmp/registry-demo

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK" /tmp/registry-demo' EXIT
cp "$TAPE" "$WORK/$NAME.tape"
(cd "$WORK" && vhs "$NAME.tape")

mkdir -p "$ROOT/media"
OUT="$ROOT/media/$NAME.gif"
if command -v gifsicle >/dev/null; then
  gifsicle -O3 --lossy=40 "$WORK/$NAME.gif" -o "$OUT"
else
  cp "$WORK/$NAME.gif" "$OUT"
fi
SIZE_MB=$(du -m "$OUT" | cut -f1)
[ "$SIZE_MB" -le 8 ] || { echo "✖ $OUT is ${SIZE_MB}MB (budget 8MB)" >&2; exit 1; }
echo "→ $OUT (${SIZE_MB}MB · budget 8MB)"
