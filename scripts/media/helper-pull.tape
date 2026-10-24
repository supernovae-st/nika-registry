# helper-pull.tape — the quick start as it runs today, in ~35 seconds:
# clone the registry, take a workflow by name with the helper (advisories,
# pinned bytes, sha256, local audit), then rehearse it on mock/echo and
# verify the run's record. Every line is the real helper's and the released
# engine's own output; scripts/media/render.sh stages the sandbox (a fresh
# HOME, a virtual environment with PyYAML, a sample transcript), pins the
# engine it found on PATH and writes the shell.zsh sourced below. House
# theme = the engine's nika-hero palette.
Output helper-pull.gif

Set Shell zsh
Set FontFamily "JetBrains Mono"
Set FontSize 21
Set Width 1420
Set Height 940
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
Type ". /tmp/nika-registry-demo/shell.zsh && clear"
Enter
Show

Type "# take a shared workflow by name · the helper checks it before it lands"
Enter
Sleep 600ms
Type "git clone -q https://github.com/supernovae-st/nika-registry"
Enter
Sleep 3000ms
Type "python3 nika-registry/scripts/get.py meeting-actions"
Enter
Sleep 7500ms

Type "clear"
Enter
Type "# rehearse it on mock/echo · no key, no network · then verify the record"
Enter
Sleep 600ms
Type "mkdir -p examples/fixtures && cp my-meeting.txt examples/fixtures/meeting-transcript.txt"
Enter
Sleep 500ms
Type "nika run meeting-actions.nika --model mock/echo"
Enter
Sleep 7000ms
Type "clear"
Enter
Type "nika trace verify"
Enter
Sleep 5500ms
Sleep 1400ms
