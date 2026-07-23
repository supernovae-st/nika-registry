# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_nika_global_optspecs
	string join \n color= hyperlink= ascii plain h/help V/version
end

function __fish_nika_needs_command
	# Figure out if the current invocation already has a command.
	set -l cmd (commandline -opc)
	set -e cmd[1]
	argparse -s (__fish_nika_global_optspecs) -- $cmd 2>/dev/null
	or return
	if set -q argv[1]
		# Also print the command, so this can be used to figure out what it is.
		echo $argv[1]
		return 1
	end
	return 0
end

function __fish_nika_using_subcommand
	set -l cmd (__fish_nika_needs_command)
	test -z "$cmd"
	and return 1
	contains -- $cmd[1] $argv
end

complete -c nika -n "__fish_nika_needs_command" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_needs_command" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_needs_command" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_needs_command" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_needs_command" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_needs_command" -s V -l version -d 'Print version'
complete -c nika -n "__fish_nika_needs_command" -f -a "welcome" -d 'The mirror: what Nika is · what this machine already has (editors · local models · key presence · this workspace) · the next commands. Offline · presence-only · always exit 0 — a greeting, not a gate'
complete -c nika -n "__fish_nika_needs_command" -f -a "check" -d 'Audit a workflow BEFORE it runs: plan · cost ceiling · secret flows · types · tools — every finding teaches its fix'
complete -c nika -n "__fish_nika_needs_command" -f -a "run" -d 'Run a workflow (the same audit runs first · live render)'
complete -c nika -n "__fish_nika_needs_command" -f -a "test" -d 'Golden test: run under the MOCK provider (offline · deterministic) and compare the typed `outputs:` against `<file>.golden.json`'
complete -c nika -n "__fish_nika_needs_command" -f -a "inspect" -d 'Static anatomy: tasks · verbs · wave groups · cost · permits — and the ONE graph projector (`--format json|mermaid|dot` for the machine surfaces · human stays the default)'
complete -c nika -n "__fish_nika_needs_command" -f -a "explain" -d 'Teach one error code (cause · category · fix-form) — or narrate a workflow FILE: what it does · the waves · cost before a token is spent · what it touches · how to run it'
complete -c nika -n "__fish_nika_needs_command" -f -a "doctor" -d 'Diagnose this machine (binary · config · provider keys · local models). Diagnose-only — prints the exact fix command, never mutates anything'
complete -c nika -n "__fish_nika_needs_command" -f -a "init" -d 'Found a repo (`.vscode` schema wiring · `AGENTS.md` · Cursor rule + MCP · `.agents/skills` authoring skill · optional workflow set). Bare on a terminal the founding wizard runs; flags are the scriptable twin. Existing files are skipped — `--force` overwrites'
complete -c nika -n "__fish_nika_needs_command" -f -a "wire" -d 'Wire Nika into editor/agent MCP clients (explicit, idempotent)'
complete -c nika -n "__fish_nika_needs_command" -f -a "model" -d 'Local models — pull from the Hugging Face Hub, serve on this machine, list/rm the disk (ONE models dir · no external daemon)'
complete -c nika -n "__fish_nika_needs_command" -f -a "spec" -d 'The embedded spec identity (`--canon` prints the SSOT)'
complete -c nika -n "__fish_nika_needs_command" -f -a "catalog" -d 'The embedded provider/model catalog (models · capabilities · env vars)'
complete -c nika -n "__fish_nika_needs_command" -f -a "examples" -d 'Browse the embedded examples'
complete -c nika -n "__fish_nika_needs_command" -f -a "new" -d 'Instantiate an embedded template skeleton'
complete -c nika -n "__fish_nika_needs_command" -f -a "completions" -d 'Generate shell completions (bash · zsh · fish · elvish · powershell)'
complete -c nika -n "__fish_nika_needs_command" -f -a "trace" -d 'Read the flight recorder (replay or summarize a run)'
complete -c nika -n "__fish_nika_needs_command" -f -a "dap" -d 'Debug Adapter Protocol server (stdio) — time-travel a recorded run under a debugger UI: breakpoints on task lines · step forward AND back through settles · outputs in the variables pane. Replay re-renders, never re-executes'
complete -c nika -n "__fish_nika_needs_command" -f -a "lsp" -d 'Run the language server over stdio (drives the editor extension)'
complete -c nika -n "__fish_nika_needs_command" -f -a "mcp" -d 'Run the MCP server (validate: check/explain · learn: schema/examples/templates/canon — the in-binary Model Context Protocol surface for Cursor · Claude Desktop · agents). Default transport: stdio; `--transport http` serves Streamable HTTP for managed hosts'
complete -c nika -n "__fish_nika_needs_command" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c nika -n "__fish_nika_using_subcommand welcome" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand welcome" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand welcome" -l json -d 'Emit the versioned machine projection (`welcome_version: 1`)'
complete -c nika -n "__fish_nika_using_subcommand welcome" -l deep -d 'The whole workspace truth (every workflow audited · recent runs · machine facts) — the deep half of the mirror (the old `context` verb, one roof)'
complete -c nika -n "__fish_nika_using_subcommand welcome" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand welcome" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand welcome" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand check" -l model -d 'Price the static envelope AS IF this `<provider>/<model>` replaced the envelope default — the preview of `nika run --model` (per-task `model:` still wins, like the runtime)' -r
complete -c nika -n "__fish_nika_using_subcommand check" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand check" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand check" -l json -d 'Emit the versioned machine projection (`report_version: 1`)'
complete -c nika -n "__fish_nika_using_subcommand check" -l infer-permits -d 'Print an inferred `permits:` boundary instead of the report'
complete -c nika -n "__fish_nika_using_subcommand check" -l fix -d 'Apply the machine-applicable rename repairs (typed did-you-mean suggestions only: fields · tools · args), rewrite the file, and re-audit — the in-binary repair loop (`clippy --fix` shape). One real file; ambiguous tokens are skipped with a note, never guessed'
complete -c nika -n "__fish_nika_using_subcommand check" -l native-strict -d 'Fail (exit 2) when any `native-first` hint remains — an `exec:` a builtin or MCP tool probably covers. The agent/CI posture; hints stay advisory without it'
complete -c nika -n "__fish_nika_using_subcommand check" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand check" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand check" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand run" -l output -d 'Print the typed `outputs:` as ONE JSON object on stdout (progress → stderr) · the export contract · powers `exec: nika run sub.yaml --output json` + `capture: stdout`' -r
complete -c nika -n "__fish_nika_using_subcommand run" -l model -d 'Override the workflow\'s envelope `model:` (`<provider>/<name>`). Resolved through the SAME path as an envelope model — a bad id fails loud when an infer/agent task resolves it. `--model mock/echo` previews any workflow offline (zero key · zero network)' -r
complete -c nika -n "__fish_nika_using_subcommand run" -l var -d 'Set a workflow `vars:` value (repeatable). Overrides a declared `default:` and satisfies a `required: true` var. The value is parsed as JSON when it parses (numbers · booleans · arrays), else taken as a string. Unknown keys are refused' -r
complete -c nika -n "__fish_nika_using_subcommand run" -l resume -d 'Resume from a prior run\'s NDJSON trace (`nika run … --json > trace.ndjson`): every task whose identity matches a journaled success is skipped with a visible `task_cache_hit` — an edited task or a changed input always re-runs (ADR-099). A trace without resume keys runs everything live (a notice, never an error)' -r -F
complete -c nika -n "__fish_nika_using_subcommand run" -l from -d 'Force this task AND its transitive downstream to re-run even on an identity match (the lever for changes the hashes cannot see — rotated secret · external state · an infer output to re-roll)' -r
complete -c nika -n "__fish_nika_using_subcommand run" -l answer -d 'Answer a paused `nika:prompt` at resume (repeatable · ADR-099 rider): binds as the named task\'s answer — `--answer ok=true` for confirm, a string for input, one of the choices for choice. The value parses as JSON when it parses, else rides as a string' -r
complete -c nika -n "__fish_nika_using_subcommand run" -l task -d 'Run ONE task and its transitive upstream only (the regenerate-one- block move): the full workflow still audits (spans · findings stay whole-file faithful), then execution scopes to the ancestor sub-DAG and the plan/cost re-derive for exactly what will run. Workflow `outputs:` are skipped (they may read unscoped tasks)' -r
complete -c nika -n "__fish_nika_using_subcommand run" -l max-cost-usd -d 'Operator run budget over METERED spend (USD). Refuses to start (exit 2) when the static cost floor already exceeds it; during the run the crossing call completes and counts, nothing new starts, unstarted tasks cancel and the run fails NIKA-1704 (exit 1) with spent-vs-budget — workflow `outputs:` are not resolved on a budget stop (per-task values live in the trace). Spending EXACTLY the budget does not trip it. Costs use LIST RATES from the vendored public catalog — private/proxy/negotiated pricing is not reflected; local · mock · unpriced work is never blocked (the budget bounds what the catalog can meter)' -r
complete -c nika -n "__fish_nika_using_subcommand run" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand run" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand run" -l json -d 'Stream NDJSON events instead of the live render (CI · agents)'
complete -c nika -n "__fish_nika_using_subcommand run" -l no-progress -d 'Plain render: one final storyboard frame, no animation (the CI-stable surface · also the default when stdout is piped). A human surface — meaningless with the `--json`/`--output` machine modes, so refused there (the machine surface owns its rendering)'
complete -c nika -n "__fish_nika_using_subcommand run" -l quiet -d 'Quiet: print only the final verdict card (errors always). A human surface · refused with `--no-progress` and the machine modes'
complete -c nika -n "__fish_nika_using_subcommand run" -l dry-run -d 'Plan only — show the static plan and execute ZERO effects (spec §10). With `--json`: ONE versioned plan object (`plan_version: 1` — waves · cost ceiling · permits · requirements) instead of the human preview. `--output` stays refused (an outputs export of a run that never executed would be a lie)'
complete -c nika -n "__fish_nika_using_subcommand run" -l no-trace-file -d 'Skip the run journal (`.nika/traces/<ts>-<id>.ndjson` · spec §3.3). Every run writes one by default so `nika trace show|replay`, `--resume` and the editor\'s runs view have a file to read. `NIKA_NO_TRACE_FILE` (any non-empty value) opts out globally'
complete -c nika -n "__fish_nika_using_subcommand run" -l no-outputs -d 'Hide the per-task output summaries (`→ {…} · 312B`) on the live storyboard. Interactive TTY only — pipes · CI · the machine modes never carry them anyway'
complete -c nika -n "__fish_nika_using_subcommand run" -l no-gc -d 'Skip the opportunistic trace collection for this invocation (ADR-100: `.nika/traces/` is bounded by default — retention rides every run start; a collection that removes anything says so on stderr)'
complete -c nika -n "__fish_nika_using_subcommand run" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand run" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand run" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand test" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand test" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand test" -l update -d '(Re)write the golden from this run instead of comparing'
complete -c nika -n "__fish_nika_using_subcommand test" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand test" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand test" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand inspect" -l format -d 'Project the graph instead of the human anatomy (json canonical · mermaid/dot derived — the docs/site surfaces)' -r -f -a "json\t'Canonical JSON projection (`graph_format: 2`)'
mermaid\t'Mermaid flowchart'
dot\t'Graphviz dot'
ascii\t'Terminal drawing (waves as columns · real wires · honest fallback)'"
complete -c nika -n "__fish_nika_using_subcommand inspect" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand inspect" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand inspect" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand inspect" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand inspect" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand explain" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand explain" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand explain" -l json -d 'File form only: emit the versioned machine projection (`explain_version: 1` · the check report\'s own vocabulary)'
complete -c nika -n "__fish_nika_using_subcommand explain" -l forecast -d 'File form only: include the learned-truth forecast — duration/ cost/risk priors from YOUR local traces (stats over `.nika/traces/` · never a model call · never the network)'
complete -c nika -n "__fish_nika_using_subcommand explain" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand explain" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand explain" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand doctor" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand doctor" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand doctor" -l ping -d 'TCP-probe the local provider ports (loopback/configured only · 300ms cap · nothing is sent on the socket). Offline without it'
complete -c nika -n "__fish_nika_using_subcommand doctor" -l json -d 'Emit the machine projection (summary + findings[] — agents/CI branch on `summary.fail` instead of parsing glyphs)'
complete -c nika -n "__fish_nika_using_subcommand doctor" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand doctor" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand doctor" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand init" -l recipe -d 'Scaffold a workflow set — the wizard\'s recipe step, scriptable (`agentic` = the 4-pattern curriculum)' -r -f -a "agentic\t''
starter\t''
ship\t''
content\t''
minimal\t''"
complete -c nika -n "__fish_nika_using_subcommand init" -l example -d 'Found the project from ONE embedded example (verbatim — any slug from `nika examples list`). One founding source: conflicts with `--recipe`' -r
complete -c nika -n "__fish_nika_using_subcommand init" -l theme -d 'Stamp the VS Code DAG canvas skin (`nika.dag.theme`) into the created `.vscode/settings.json`' -r -f -a "nika\t'The brand skin — engineered black · verb hues'
editor\t'Adaptive — follows the editor\'s colors'
phosphor\t'Terminal green'
auto\t'Let the extension decide'"
complete -c nika -n "__fish_nika_using_subcommand init" -l wire -d 'Wire agent clients to the MCP oracle after the scaffold (comma-separated · the same targets as `nika wire`)' -r -f -a "cursor\t''
vscode\t''
windsurf\t''
claude\t''
claude-desktop\t''
cline\t''
codex\t''
continue\t''
zed\t''
opencode\t''
hermes\t''
gemini\t''
qwen\t''
lmstudio\t''
junie\t''
all\t''"
complete -c nika -n "__fish_nika_using_subcommand init" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand init" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand init" -l force -d 'Overwrite existing files'
complete -c nika -n "__fish_nika_using_subcommand init" -s y -l yes -d 'Accept every default — never prompt (pipes and CI are implicitly `--yes`; prompts only ever appear on a terminal)'
complete -c nika -n "__fish_nika_using_subcommand init" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand init" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand init" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand wire" -l dir -d 'Workspace directory for repo-local clients such as VS Code' -r
complete -c nika -n "__fish_nika_using_subcommand wire" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand wire" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand wire" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand wire" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand wire" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand model; and not __fish_seen_subcommand_from serve pull list rm help" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand model; and not __fish_seen_subcommand_from serve pull list rm help" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand model; and not __fish_seen_subcommand_from serve pull list rm help" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand model; and not __fish_seen_subcommand_from serve pull list rm help" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand model; and not __fish_seen_subcommand_from serve pull list rm help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand model; and not __fish_seen_subcommand_from serve pull list rm help" -f -a "serve" -d 'Serve a GGUF model — an OpenAI-compatible foreground server on 127.0.0.1 (Ctrl-C stops it · the banner says how workflows reach it)'
complete -c nika -n "__fish_nika_using_subcommand model; and not __fish_seen_subcommand_from serve pull list rm help" -f -a "pull" -d 'Download a GGUF from the Hugging Face Hub into the ONE models dir (`~/.nika/models` — the same dir `serve --model <id>` resolves, by construction). Size prints BEFORE downloading; 2 GiB and over confirms (`--yes` for CI). An interrupted pull resumes from its `.part`. `HF_TOKEN` authenticates gated repos. This fetch is CLI-level, like `registry:` pulls — a workflow\'s `permits:` never govern it'
complete -c nika -n "__fish_nika_using_subcommand model; and not __fish_seen_subcommand_from serve pull list rm help" -f -a "list" -d 'What\'s on disk: id · size · file per GGUF — the ONE models dir printed once at top'
complete -c nika -n "__fish_nika_using_subcommand model; and not __fish_seen_subcommand_from serve pull list rm help" -f -a "rm" -d 'Remove a pulled model: `owner/repo` removes every quant (and the tokenizer beside them) · `owner/repo:QUANT` one file. A no-match refuses, listing what IS there'
complete -c nika -n "__fish_nika_using_subcommand model; and not __fish_seen_subcommand_from serve pull list rm help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from serve" -l model -d 'The model: a `.gguf` path, or a pulled id — `owner/repo[:QUANT]` or a file stem, resolved against the models dir (`nika model list`)' -r
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from serve" -l tokenizer -d 'The tokenizer file (default: `tokenizer.json` beside the model)' -r -F
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from serve" -l port -d 'Loopback port to listen on' -r
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from serve" -l model-id -d 'The model id responses report (default: the model file\'s name)' -r
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from serve" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from serve" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from serve" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from serve" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from serve" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from pull" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from pull" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from pull" -s y -l yes -d 'Skip the size confirmation (CI · scripts)'
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from pull" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from pull" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from pull" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from list" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from list" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from list" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from list" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from rm" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from rm" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from rm" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from rm" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from rm" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from help" -f -a "serve" -d 'Serve a GGUF model — an OpenAI-compatible foreground server on 127.0.0.1 (Ctrl-C stops it · the banner says how workflows reach it)'
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from help" -f -a "pull" -d 'Download a GGUF from the Hugging Face Hub into the ONE models dir (`~/.nika/models` — the same dir `serve --model <id>` resolves, by construction). Size prints BEFORE downloading; 2 GiB and over confirms (`--yes` for CI). An interrupted pull resumes from its `.part`. `HF_TOKEN` authenticates gated repos. This fetch is CLI-level, like `registry:` pulls — a workflow\'s `permits:` never govern it'
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from help" -f -a "list" -d 'What\'s on disk: id · size · file per GGUF — the ONE models dir printed once at top'
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from help" -f -a "rm" -d 'Remove a pulled model: `owner/repo` removes every quant (and the tokenizer beside them) · `owner/repo:QUANT` one file. A no-match refuses, listing what IS there'
complete -c nika -n "__fish_nika_using_subcommand model; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c nika -n "__fish_nika_using_subcommand spec" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand spec" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand spec" -l canon -d 'Print the canon.yaml single source of truth'
complete -c nika -n "__fish_nika_using_subcommand spec" -l schema -d 'Print the embedded JSON Schema for `*.nika.yaml` (the old `schema` verb, one roof)'
complete -c nika -n "__fish_nika_using_subcommand spec" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand spec" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand spec" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand catalog" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand catalog" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand catalog" -l json -d 'Emit the versioned machine projection (`catalog_version: 1`)'
complete -c nika -n "__fish_nika_using_subcommand catalog" -l tools -d 'The `nika:*` builtin tool catalog instead (what `invoke` reaches without MCP — the old `tools` verb, one roof)'
complete -c nika -n "__fish_nika_using_subcommand catalog" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand catalog" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand catalog" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand examples; and not __fish_seen_subcommand_from list show copy run help" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand examples; and not __fish_seen_subcommand_from list show copy run help" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand examples; and not __fish_seen_subcommand_from list show copy run help" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand examples; and not __fish_seen_subcommand_from list show copy run help" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand examples; and not __fish_seen_subcommand_from list show copy run help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand examples; and not __fish_seen_subcommand_from list show copy run help" -f -a "list" -d 'List the embedded example slugs'
complete -c nika -n "__fish_nika_using_subcommand examples; and not __fish_seen_subcommand_from list show copy run help" -f -a "show" -d 'Print one embedded example'
complete -c nika -n "__fish_nika_using_subcommand examples; and not __fish_seen_subcommand_from list show copy run help" -f -a "copy" -d 'Copy an embedded example into YOUR workspace (make it yours)'
complete -c nika -n "__fish_nika_using_subcommand examples; and not __fish_seen_subcommand_from list show copy run help" -f -a "run" -d 'Run an embedded example (audited first · live render)'
complete -c nika -n "__fish_nika_using_subcommand examples; and not __fish_seen_subcommand_from list show copy run help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from list" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from list" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from list" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from list" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from show" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from show" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from show" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from show" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from copy" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from copy" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from copy" -l force -d 'Overwrite an existing destination'
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from copy" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from copy" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from copy" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from run" -l model -d 'Override the example\'s `model:` (`<provider>/<name>`). Use `--model mock/echo` to preview offline (zero key · zero network)' -r
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from run" -l var -d 'Set a workflow `vars:` input (repeatable) — several examples declare required vars and say so in their header' -r
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from run" -l max-cost-usd -d 'Refuse to start if the static cost floor exceeds this (USD); metered spend aborts past it mid-run. Same guard, same parser as `nika run` — a NaN/inf here would silently disarm the budget (every comparison false), the exact class the parser exists to kill' -r
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from run" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from run" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from run" -l quiet -d 'Verdict line only (suppress the storyboard)'
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from run" -l no-progress -d 'One final storyboard frame (no live repaints) — pipes/CI get this automatically'
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from run" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from run" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from run" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from help" -f -a "list" -d 'List the embedded example slugs'
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from help" -f -a "show" -d 'Print one embedded example'
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from help" -f -a "copy" -d 'Copy an embedded example into YOUR workspace (make it yours)'
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from help" -f -a "run" -d 'Run an embedded example (audited first · live render)'
complete -c nika -n "__fish_nika_using_subcommand examples; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c nika -n "__fish_nika_using_subcommand new" -l from -d 'Template name or plain-words intent (`--from \'?\'` lists the set). Omitted on a terminal → the guided three-question flow; omitted in a pipe → fail fast naming this flag' -r
complete -c nika -n "__fish_nika_using_subcommand new" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand new" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand new" -l force -d 'Overwrite an existing destination'
complete -c nika -n "__fish_nika_using_subcommand new" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand new" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand new" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand completions" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand completions" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand completions" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand completions" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand completions" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay show ls rm outputs export verify reproduce peek flow help" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay show ls rm outputs export verify reproduce peek flow help" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay show ls rm outputs export verify reproduce peek flow help" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay show ls rm outputs export verify reproduce peek flow help" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay show ls rm outputs export verify reproduce peek flow help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay show ls rm outputs export verify reproduce peek flow help" -f -a "replay" -d 'Re-render a run live (replay = re-render, NEVER re-execute)'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay show ls rm outputs export verify reproduce peek flow help" -f -a "show" -d 'Print the final card only'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay show ls rm outputs export verify reproduce peek flow help" -f -a "ls" -d 'List the workspace trace store (`.nika/traces/`): age · size · workflow · terminal state (completed/failed/paused) · the resume-candidate marker (★ — the newest of each workflow, the trace retention never collects · ADR-100)'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay show ls rm outputs export verify reproduce peek flow help" -f -a "rm" -d 'Remove traces from the store — one by name/path, `--older-than <dur>`, or `--all`. Removing a paused trace refuses without `--force` and names the unanswered prompt it would destroy (ADR-100)'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay show ls rm outputs export verify reproduce peek flow help" -f -a "outputs" -d 'Browse per-task outputs: verb · duration · tokens · bounded preview (full value: `trace peek`)'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay show ls rm outputs export verify reproduce peek flow help" -f -a "export" -d 'Project the journal to OTLP/JSON lines — every `OTel` tool becomes a viewer (drag into Jaeger UI ≥1.60 · POST lines to any OTLP/HTTP endpoint). Local file, zero collector, zero vendor'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay show ls rm outputs export verify reproduce peek flow help" -f -a "verify" -d 'Verify the journal\'s tamper-evidence chain (0.96+): any edited, inserted, dropped or reordered line breaks every hash after it. Exit 0 intact · 2 broken · 3 unchained (pre-chain journal)'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay show ls rm outputs export verify reproduce peek flow help" -f -a "reproduce" -d 'Is this run reproducible? Compare a recorded journal against a fresh one and classify every task: reproduced · nondeterministic (same def+inputs, different output) · authored · environment · status-changed · unverifiable. Exit 0 reproduced · 2 diverged'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay show ls rm outputs export verify reproduce peek flow help" -f -a "peek" -d 'Read ONE task\'s full output + its identity (hashes · duration · tokens). `--raw` prints the exact value only (pipe it to jq)'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay show ls rm outputs export verify reproduce peek flow help" -f -a "flow" -d 'The data waterfall: which output fed which task, with recorded sizes (plan bindings from the workflow file × sizes from the trace)'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay show ls rm outputs export verify reproduce peek flow help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from replay" -l speed -d 'Replay time compression (6 = 6× faster than recorded)' -r
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from replay" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from replay" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from replay" -l demo -d 'Render the built-in success storyboard'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from replay" -l demo-fail -d 'Render the built-in failure storyboard'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from replay" -l no-outputs -d 'Hide the per-task output summaries (`→ {…} · 312B`) on the rendered storyboard. Interactive TTY only — a piped `trace show` never carries them anyway'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from replay" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from replay" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from replay" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from show" -l speed -d 'Replay time compression (6 = 6× faster than recorded)' -r
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from show" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from show" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from show" -l demo -d 'Render the built-in success storyboard'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from show" -l demo-fail -d 'Render the built-in failure storyboard'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from show" -l no-outputs -d 'Hide the per-task output summaries (`→ {…} · 312B`) on the rendered storyboard. Interactive TTY only — a piped `trace show` never carries them anyway'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from show" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from show" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from ls" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from ls" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from ls" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from ls" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from rm" -l older-than -d 'Remove every trace older than this (`45s` · `30m` · `12h` · `7d`)' -r
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from rm" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from rm" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from rm" -l all -d 'Remove every trace in the store'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from rm" -l force -d 'Remove even a paused trace (destroys its unanswered prompt)'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from rm" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from rm" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from rm" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from outputs" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from outputs" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from outputs" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from outputs" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from outputs" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from export" -s o -l out -d 'Output path (default: `<trace>.otlp.jsonl` beside the journal)' -r -F
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from export" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from export" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from export" -l include-content -d 'Include recorded task outputs as span attributes (payloads stay LOCAL either way — this only widens the exported file)'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from export" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from export" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from export" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from verify" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from verify" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from verify" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from verify" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from verify" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from reproduce" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from reproduce" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from reproduce" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from reproduce" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from reproduce" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from peek" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from peek" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from peek" -l raw -d 'Print the exact recorded value only (machine-friendly)'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from peek" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from peek" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from peek" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from flow" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from flow" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from flow" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from flow" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from flow" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "replay" -d 'Re-render a run live (replay = re-render, NEVER re-execute)'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "show" -d 'Print the final card only'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "ls" -d 'List the workspace trace store (`.nika/traces/`): age · size · workflow · terminal state (completed/failed/paused) · the resume-candidate marker (★ — the newest of each workflow, the trace retention never collects · ADR-100)'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "rm" -d 'Remove traces from the store — one by name/path, `--older-than <dur>`, or `--all`. Removing a paused trace refuses without `--force` and names the unanswered prompt it would destroy (ADR-100)'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "outputs" -d 'Browse per-task outputs: verb · duration · tokens · bounded preview (full value: `trace peek`)'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "export" -d 'Project the journal to OTLP/JSON lines — every `OTel` tool becomes a viewer (drag into Jaeger UI ≥1.60 · POST lines to any OTLP/HTTP endpoint). Local file, zero collector, zero vendor'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "verify" -d 'Verify the journal\'s tamper-evidence chain (0.96+): any edited, inserted, dropped or reordered line breaks every hash after it. Exit 0 intact · 2 broken · 3 unchained (pre-chain journal)'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "reproduce" -d 'Is this run reproducible? Compare a recorded journal against a fresh one and classify every task: reproduced · nondeterministic (same def+inputs, different output) · authored · environment · status-changed · unverifiable. Exit 0 reproduced · 2 diverged'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "peek" -d 'Read ONE task\'s full output + its identity (hashes · duration · tokens). `--raw` prints the exact value only (pipe it to jq)'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "flow" -d 'The data waterfall: which output fed which task, with recorded sizes (plan bindings from the workflow file × sizes from the trace)'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c nika -n "__fish_nika_using_subcommand dap" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand dap" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand dap" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand dap" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand dap" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand lsp" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand lsp" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand lsp" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand lsp" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand lsp" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand mcp" -l transport -d 'The wire: `stdio` (the editor/agent default) or `http` (Streamable HTTP · POST JSON-RPC · spec 2025-11-25)' -r -f -a "stdio\t'Newline-delimited JSON-RPC over stdin/stdout'
http\t'Streamable HTTP (POST JSON-RPC · origin-gated · loopback default)'"
complete -c nika -n "__fish_nika_using_subcommand mcp" -l port -d 'HTTP port (with `--transport http`)' -r
complete -c nika -n "__fish_nika_using_subcommand mcp" -l bind -d 'HTTP bind address. Loopback by default — widening this exposes the server to your network; put TLS + auth (a reverse proxy · `NIKA_MCP_TOKEN`) in front before you do' -r
complete -c nika -n "__fish_nika_using_subcommand mcp" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand mcp" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand mcp" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand mcp" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand mcp" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from welcome check run test inspect explain doctor init wire model spec catalog examples new completions trace dap lsp mcp help" -f -a "welcome" -d 'The mirror: what Nika is · what this machine already has (editors · local models · key presence · this workspace) · the next commands. Offline · presence-only · always exit 0 — a greeting, not a gate'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from welcome check run test inspect explain doctor init wire model spec catalog examples new completions trace dap lsp mcp help" -f -a "check" -d 'Audit a workflow BEFORE it runs: plan · cost ceiling · secret flows · types · tools — every finding teaches its fix'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from welcome check run test inspect explain doctor init wire model spec catalog examples new completions trace dap lsp mcp help" -f -a "run" -d 'Run a workflow (the same audit runs first · live render)'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from welcome check run test inspect explain doctor init wire model spec catalog examples new completions trace dap lsp mcp help" -f -a "test" -d 'Golden test: run under the MOCK provider (offline · deterministic) and compare the typed `outputs:` against `<file>.golden.json`'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from welcome check run test inspect explain doctor init wire model spec catalog examples new completions trace dap lsp mcp help" -f -a "inspect" -d 'Static anatomy: tasks · verbs · wave groups · cost · permits — and the ONE graph projector (`--format json|mermaid|dot` for the machine surfaces · human stays the default)'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from welcome check run test inspect explain doctor init wire model spec catalog examples new completions trace dap lsp mcp help" -f -a "explain" -d 'Teach one error code (cause · category · fix-form) — or narrate a workflow FILE: what it does · the waves · cost before a token is spent · what it touches · how to run it'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from welcome check run test inspect explain doctor init wire model spec catalog examples new completions trace dap lsp mcp help" -f -a "doctor" -d 'Diagnose this machine (binary · config · provider keys · local models). Diagnose-only — prints the exact fix command, never mutates anything'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from welcome check run test inspect explain doctor init wire model spec catalog examples new completions trace dap lsp mcp help" -f -a "init" -d 'Found a repo (`.vscode` schema wiring · `AGENTS.md` · Cursor rule + MCP · `.agents/skills` authoring skill · optional workflow set). Bare on a terminal the founding wizard runs; flags are the scriptable twin. Existing files are skipped — `--force` overwrites'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from welcome check run test inspect explain doctor init wire model spec catalog examples new completions trace dap lsp mcp help" -f -a "wire" -d 'Wire Nika into editor/agent MCP clients (explicit, idempotent)'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from welcome check run test inspect explain doctor init wire model spec catalog examples new completions trace dap lsp mcp help" -f -a "model" -d 'Local models — pull from the Hugging Face Hub, serve on this machine, list/rm the disk (ONE models dir · no external daemon)'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from welcome check run test inspect explain doctor init wire model spec catalog examples new completions trace dap lsp mcp help" -f -a "spec" -d 'The embedded spec identity (`--canon` prints the SSOT)'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from welcome check run test inspect explain doctor init wire model spec catalog examples new completions trace dap lsp mcp help" -f -a "catalog" -d 'The embedded provider/model catalog (models · capabilities · env vars)'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from welcome check run test inspect explain doctor init wire model spec catalog examples new completions trace dap lsp mcp help" -f -a "examples" -d 'Browse the embedded examples'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from welcome check run test inspect explain doctor init wire model spec catalog examples new completions trace dap lsp mcp help" -f -a "new" -d 'Instantiate an embedded template skeleton'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from welcome check run test inspect explain doctor init wire model spec catalog examples new completions trace dap lsp mcp help" -f -a "completions" -d 'Generate shell completions (bash · zsh · fish · elvish · powershell)'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from welcome check run test inspect explain doctor init wire model spec catalog examples new completions trace dap lsp mcp help" -f -a "trace" -d 'Read the flight recorder (replay or summarize a run)'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from welcome check run test inspect explain doctor init wire model spec catalog examples new completions trace dap lsp mcp help" -f -a "dap" -d 'Debug Adapter Protocol server (stdio) — time-travel a recorded run under a debugger UI: breakpoints on task lines · step forward AND back through settles · outputs in the variables pane. Replay re-renders, never re-executes'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from welcome check run test inspect explain doctor init wire model spec catalog examples new completions trace dap lsp mcp help" -f -a "lsp" -d 'Run the language server over stdio (drives the editor extension)'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from welcome check run test inspect explain doctor init wire model spec catalog examples new completions trace dap lsp mcp help" -f -a "mcp" -d 'Run the MCP server (validate: check/explain · learn: schema/examples/templates/canon — the in-binary Model Context Protocol surface for Cursor · Claude Desktop · agents). Default transport: stdio; `--transport http` serves Streamable HTTP for managed hosts'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from welcome check run test inspect explain doctor init wire model spec catalog examples new completions trace dap lsp mcp help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from model" -f -a "serve" -d 'Serve a GGUF model — an OpenAI-compatible foreground server on 127.0.0.1 (Ctrl-C stops it · the banner says how workflows reach it)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from model" -f -a "pull" -d 'Download a GGUF from the Hugging Face Hub into the ONE models dir (`~/.nika/models` — the same dir `serve --model <id>` resolves, by construction). Size prints BEFORE downloading; 2 GiB and over confirms (`--yes` for CI). An interrupted pull resumes from its `.part`. `HF_TOKEN` authenticates gated repos. This fetch is CLI-level, like `registry:` pulls — a workflow\'s `permits:` never govern it'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from model" -f -a "list" -d 'What\'s on disk: id · size · file per GGUF — the ONE models dir printed once at top'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from model" -f -a "rm" -d 'Remove a pulled model: `owner/repo` removes every quant (and the tokenizer beside them) · `owner/repo:QUANT` one file. A no-match refuses, listing what IS there'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from examples" -f -a "list" -d 'List the embedded example slugs'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from examples" -f -a "show" -d 'Print one embedded example'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from examples" -f -a "copy" -d 'Copy an embedded example into YOUR workspace (make it yours)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from examples" -f -a "run" -d 'Run an embedded example (audited first · live render)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "replay" -d 'Re-render a run live (replay = re-render, NEVER re-execute)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "show" -d 'Print the final card only'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "ls" -d 'List the workspace trace store (`.nika/traces/`): age · size · workflow · terminal state (completed/failed/paused) · the resume-candidate marker (★ — the newest of each workflow, the trace retention never collects · ADR-100)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "rm" -d 'Remove traces from the store — one by name/path, `--older-than <dur>`, or `--all`. Removing a paused trace refuses without `--force` and names the unanswered prompt it would destroy (ADR-100)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "outputs" -d 'Browse per-task outputs: verb · duration · tokens · bounded preview (full value: `trace peek`)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "export" -d 'Project the journal to OTLP/JSON lines — every `OTel` tool becomes a viewer (drag into Jaeger UI ≥1.60 · POST lines to any OTLP/HTTP endpoint). Local file, zero collector, zero vendor'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "verify" -d 'Verify the journal\'s tamper-evidence chain (0.96+): any edited, inserted, dropped or reordered line breaks every hash after it. Exit 0 intact · 2 broken · 3 unchained (pre-chain journal)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "reproduce" -d 'Is this run reproducible? Compare a recorded journal against a fresh one and classify every task: reproduced · nondeterministic (same def+inputs, different output) · authored · environment · status-changed · unverifiable. Exit 0 reproduced · 2 diverged'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "peek" -d 'Read ONE task\'s full output + its identity (hashes · duration · tokens). `--raw` prints the exact value only (pipe it to jq)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "flow" -d 'The data waterfall: which output fed which task, with recorded sizes (plan bindings from the workflow file × sizes from the trace)'
