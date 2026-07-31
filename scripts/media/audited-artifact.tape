# audited-artifact.tape — the market's story in ~12 seconds: one command
# fetches an entry, verifies its digest against the pinned sha256, and
# runs the same static audit every local file gets — before a token is
# spent. Every verdict is the released binary's own against the LIVE
# registry; scripts/media/render.sh clears the cache first so the fetch
# is real. House theme = the engine palette + the v2 window chrome.
Output audited-artifact.gif

Set Shell zsh
Set FontFamily "JetBrains Mono"
Set FontSize 21
Set Width 1420
Set Height 780
Set Padding 24
Set Margin 22
Set MarginFill "#4f86ff"
Set BorderRadius 14
Set WindowBar Colorful
Set WindowBarSize 42
Set Theme { "name": "nika", "background": "#08090b", "foreground": "#dbe3ee", "cursor": "#4f86ff", "black": "#10131a", "red": "#ff6b6b", "green": "#34d399", "yellow": "#f0b45b", "blue": "#4f86ff", "magenta": "#b07bff", "cyan": "#22d3ee", "white": "#dbe3ee", "brightBlack": "#5b6472", "brightRed": "#ff8f8f", "brightGreen": "#5ee6b0", "brightYellow": "#ffd08a", "brightBlue": "#8db4ff", "brightMagenta": "#c9a2ff", "brightCyan": "#67e3f5", "brightWhite": "#ffffff" }
Set TypingSpeed 30ms
Set PlaybackSpeed 1.0

Hide
Type "cd /tmp/registry-demo && export TMPDIR=/tmp && unset -m '*API_KEY*' '*_TOKEN*' '*SECRET*' 2>/dev/null; setopt interactive_comments && clear"
Enter
Show

Type "# an artifact from the market · fetched, digest-verified, then AUDITED"
Enter
Sleep 700ms
Type "nika check registry:supernovae-st/release-radar"
Enter
Sleep 6200ms

Type "# cached now · later runs are offline, the same audit every time"
Enter
Sleep 1600ms
Sleep 1200ms
