#!/usr/bin/env bash
# render.sh — render a registry tape against a released engine and the LIVE
# registry. Sibling of the engine's render-tape.sh · same honesty contract:
# every line on screen is the helper's, git's or the engine's own output.
# The sandbox (/tmp/nika-registry-demo) is a fresh HOME with the engine to
# record, a virtual environment with PyYAML for the helper and a sample
# transcript; nothing outside it is touched. The tape sources shell.zsh,
# written below, before it shows anything.
# Usage: bash scripts/media/render.sh [tape-name]
#   NIKA_BIN    the engine to record (default: the nika on PATH)
#   TRANSCRIPT  also write the final screen, as text, to this file
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
NAME="${1:-helper-pull}"
TAPE="$ROOT/scripts/media/$NAME.tape"
[ -f "$TAPE" ] || { echo "no tape at $TAPE" >&2; exit 1; }
command -v vhs >/dev/null || { echo "vhs not installed (brew install vhs)" >&2; exit 1; }
command -v python3 >/dev/null || { echo "python3 not on PATH" >&2; exit 1; }
NIKA="${NIKA_BIN:-$(command -v nika || true)}"
[ -n "$NIKA" ] && [ -x "$NIKA" ] || { echo "nika not found (set NIKA_BIN)" >&2; exit 1; }

SANDBOX=/tmp/nika-registry-demo
rm -rf "$SANDBOX"
mkdir -p "$SANDBOX/bin" "$SANDBOX/work"
ln -s "$NIKA" "$SANDBOX/bin/nika"
HOME="$SANDBOX" "$SANDBOX/bin/nika" --version >/dev/null || {
  echo "the engine must answer under the sandbox HOME (a proxy may need NIKA_BIN)" >&2
  exit 1
}
python3 -m venv "$SANDBOX/venv"
"$SANDBOX/venv/bin/pip" install --quiet pyyaml
printf '%s\n' \
  'Ana: I will send the pricing deck to the client by Friday.' \
  'Ben: I will fix the login bug before the release on the 30th.' \
  'Chloe: Can someone book the room for the retro? Ana: I will, tomorrow.' \
  > "$SANDBOX/work/my-meeting.txt"

# The recorded shell: a fresh HOME, the engine first on a short PATH (no
# agent CLI for the engine to probe), no credential variables, no keychain.
# The engine prints a home-isolation notice when stderr is a terminal and HOME
# is not the account home; its stderr reaches the screen through a pipe here,
# so that notice (it names the sandbox) stays out, as the engine's own media
# captures keep it out. stdout is still the terminal, and the exit code is the
# engine's own.
cat > "$SANDBOX/shell.zsh" <<EOF
export HOME=$SANDBOX TMPDIR=/tmp NIKA_KEYCHAIN=off
export PATH=$SANDBOX/bin:/usr/bin:/bin
. $SANDBOX/venv/bin/activate
unset -m '*API_KEY*' '*_TOKEN*' '*SECRET*' 2>/dev/null
setopt interactive_comments
nika() {
  setopt localoptions nomultios
  local code
  { command nika "\$@" 2>&1 1>&3 3>&- | { grep -v '^nika: home isolation:' >&2 || true; }; code=\${pipestatus[1]}; } 3>&1
  return \$code
}
cd $SANDBOX/work
EOF

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK" "$SANDBOX"' EXIT
cp "$TAPE" "$WORK/$NAME.tape"
[ -z "${TRANSCRIPT:-}" ] || printf 'Output %s.txt\n' "$NAME" >> "$WORK/$NAME.tape"
(cd "$WORK" && vhs "$NAME.tape")
[ -z "${TRANSCRIPT:-}" ] || cp "$WORK/$NAME.txt" "$TRANSCRIPT"

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
