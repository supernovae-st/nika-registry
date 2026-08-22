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
complete -c nika -n "__fish_nika_needs_command" -f -a "list" -d 'List the workflows below this directory, one relative path per line'
complete -c nika -n "__fish_nika_needs_command" -f -a "welcome" -d 'The mirror: what Nika is · what this machine already has (editors · local models · key presence · this workspace) · the next commands. Offline · presence-only · always exit 0 — a greeting, not a gate'
complete -c nika -n "__fish_nika_needs_command" -f -a "check" -d 'Audit a workflow BEFORE it runs: plan · cost ceiling · secret flows · types · tools — every finding teaches its fix'
complete -c nika -n "__fish_nika_needs_command" -f -a "run" -d 'Run a workflow (the same audit runs first · live render)'
complete -c nika -n "__fish_nika_needs_command" -f -a "test" -d 'Golden test: run under the MOCK provider (offline · deterministic) and compare the typed `outputs:` against `<file>.golden.json`'
complete -c nika -n "__fish_nika_needs_command" -f -a "inspect" -d 'Static anatomy: tasks · verbs · wave groups · cost · permits — and the ONE graph projector (`--format json|mermaid|dot` for the machine surfaces · human stays the default)'
complete -c nika -n "__fish_nika_needs_command" -f -a "explain" -d 'Teach one error code (cause · category · fix-form) — or narrate a workflow FILE: what it does · the waves · cost before a token is spent · what it touches · how to run it'
complete -c nika -n "__fish_nika_needs_command" -f -a "key" -d 'The run-signing key lifecycle (mint · TOFU fingerprint · rotate — old pubs stay verifiable)'
complete -c nika -n "__fish_nika_needs_command" -f -a "arm" -d 'What this project has ARMED, and when each beat next fires. Read-only — it schedules nothing (the file proposes, the machine disposes). Exit `0` clean · `2` the registry refuses'
complete -c nika -n "__fish_nika_needs_command" -f -a "serve" -d 'The resident firer: the SAME `fire`, the wall clock in place of the OS (W5). Exit `0` clean · `1` otherwise'
complete -c nika -n "__fish_nika_needs_command" -f -a "sign" -d 'Sign a workflow file (S3 · author-binding): mint `<file>.minisig` · `--check` verifies'
complete -c nika -n "__fish_nika_needs_command" -f -a "doctor" -d 'Diagnose this machine (binary · config · provider keys · local models). Diagnose-only — prints the exact fix command, never mutates anything'
complete -c nika -n "__fish_nika_needs_command" -f -a "init" -d 'Found a repo (`.vscode` schema wiring · `AGENTS.md` · Cursor rule + MCP · `.agents/skills` authoring skill · optional workflow set). Bare on a terminal the founding wizard runs; flags are the scriptable twin. Existing files are skipped — `--force` overwrites'
complete -c nika -n "__fish_nika_needs_command" -f -a "wire" -d 'Wire Nika into editor/agent MCP clients (explicit, idempotent). The door: `detected --dry-run` previews what this machine shows · `detected` wires it · `<client>` wires one · `all` is the advanced sweep (previewed, then confirmed or `--yes`)'
complete -c nika -n "__fish_nika_needs_command" -f -a "model" -d 'Local models — pull from the Hugging Face Hub, serve on this machine, list/rm the disk (ONE models dir · no external daemon)'
complete -c nika -n "__fish_nika_needs_command" -f -a "spec" -d 'The embedded spec identity (`--canon` prints the SSOT)'
complete -c nika -n "__fish_nika_needs_command" -f -a "catalog" -d 'The embedded provider/model catalog (models · capabilities · env vars)'
complete -c nika -n "__fish_nika_needs_command" -f -a "try" -d 'See a canonical workflow WORK — offline by default (the mock rehearsal · zero keys · zero flags), nothing written, nothing owned. Bare `nika try` lists what there is to see'
complete -c nika -n "__fish_nika_needs_command" -f -a "new" -d 'The ONE creation door: describe the job in plain words (routes), or name a slug/skeleton (takes it, ingredients included) — the destination derives from the slug. Plain words route across jobs, lessons and skeletons. Bare `nika new` on a terminal is the guided flow; `nika new \'?\'` lists the skeleton set'
complete -c nika -n "__fish_nika_needs_command" -f -a "completions" -d 'Generate shell completions (bash · zsh · fish · elvish · powershell)'
complete -c nika -n "__fish_nika_needs_command" -f -a "trace" -d 'Read the flight recorder (replay or summarize a run)'
complete -c nika -n "__fish_nika_needs_command" -f -a "guard" -d 'The hook\'s judge (hidden — the wired `guard-run.sh` shim calls it, agents never type it): read a host hook payload (`--stdin`) or one command line (`--command`), find every effective `nika run`, audit the EXACT file in-process, and answer the hook protocol. P0-7 + P0-15: a red file or a priced model without `--max-cost-usd` is denied; an unjudgeable run is a VISIBLE `guard_unavailable`, never a silent allow. The run belongs to the human — guard JUDGES, it never executes'
complete -c nika -n "__fish_nika_needs_command" -f -a "dap" -d 'Debug Adapter Protocol server (stdio) — time-travel a recorded run under a debugger UI: breakpoints on task lines · step forward AND back through settles · outputs in the variables pane. Replay re-renders, never re-executes'
complete -c nika -n "__fish_nika_needs_command" -f -a "lsp" -d 'Run the language server over stdio (drives the editor extension)'
complete -c nika -n "__fish_nika_needs_command" -f -a "mcp" -d 'Run the MCP server (validate: check/explain · learn: schema/examples/templates/canon — the in-binary Model Context Protocol surface for Cursor · Claude Desktop · agents). Default transport: stdio; `--transport http` serves Streamable HTTP for managed hosts. `approve` runs the CLIENT side: the MCP tool-pinning re-approval over the servers configured in `.nika/mcp_servers.json`'
complete -c nika -n "__fish_nika_needs_command" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c nika -n "__fish_nika_using_subcommand list" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand list" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand list" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand list" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand list" -s h -l help -d 'Print help (see more with \'--help\')'
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
complete -c nika -n "__fish_nika_using_subcommand check" -l profile -d 'Advisory displays the grade; operational fails at High/Unbounded' -r -f -a "advisory\t'Grade displayed, never gating (the default)'
operational\t'Grade ≥ High fails the audit (exit 2)'"
complete -c nika -n "__fish_nika_using_subcommand check" -l model -d 'Price as if this `<provider>/<model>` replaced the envelope default' -r
complete -c nika -n "__fish_nika_using_subcommand check" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand check" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand check" -l json -d 'Machine projection (`report_version: 1`)'
complete -c nika -n "__fish_nika_using_subcommand check" -l infer-permits -d 'Print an inferred `permits:` boundary'
complete -c nika -n "__fish_nika_using_subcommand check" -l fix -d 'Apply typed rename repairs and re-audit'
complete -c nika -n "__fish_nika_using_subcommand check" -l native-strict -d 'Fail when any `native-first` hint remains'
complete -c nika -n "__fish_nika_using_subcommand check" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand check" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand check" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand run" -l output -d 'Print the typed `outputs:` as ONE JSON object on stdout (progress → stderr) · the export contract · powers `exec: nika run sub.yaml --output json` + `capture: stdout`' -r
complete -c nika -n "__fish_nika_using_subcommand run" -l model -d 'Override the workflow\'s envelope `model:` (`<provider>/<name>`). Resolved through the SAME path as an envelope model — a bad id fails loud when an infer/agent task resolves it. `--model mock/echo` previews any workflow offline (zero key · zero network)' -r
complete -c nika -n "__fish_nika_using_subcommand run" -l access -d 'Pin the ACCESS path (`model:` picks the intelligence; access picks the path) — an access class (`local` · `api` · `harness` · `oauth` · `mock`) or an access id `nika doctor` lists. A pin is a pin: unsatisfied refuses before the prologue with a witness, never substitutes another path or model (D-2026-08-04-N1)' -r
complete -c nika -n "__fish_nika_using_subcommand run" -l var -d 'Set a workflow `inputs:` value (repeatable). Overrides a declared `default:` and satisfies a `required: true` input. JSON when it parses (numbers · booleans · arrays), else a string. Unknown keys refused' -r
complete -c nika -n "__fish_nika_using_subcommand run" -l resume -d 'Resume from a prior run\'s NDJSON trace (`nika run … --json > trace.ndjson`): every task whose identity matches a journaled success is skipped with a visible `task_cache_hit` — an edited task or a changed input always re-runs (ADR-099). A trace without resume keys runs everything live (a notice, never an error). The trace\'s tamper-evidence chain is VERIFIED before any record is trusted: a broken chain refuses (exit 2), naming `nika trace verify` and the `--resume-unverified` opt-out. The trace\'s recorded engine version is JUDGED (F-P21): a resume under a different engine refuses, naming both versions' -r -F
complete -c nika -n "__fish_nika_using_subcommand run" -l resume-compat -d 'Declare a cross-version resume compatible (F-P21 · NEP-0014 law 4): attests the trace recorded under engine `<VERSION>` may resume under this one — the token must name the trace\'s recorded version exactly (`unrecorded` for a pre-versioning journal). The declared compat is journaled on the run\'s boot manifest' -r
complete -c nika -n "__fish_nika_using_subcommand run" -l from -d 'Force this task AND its transitive downstream to re-run even on an identity match (the lever for changes the hashes cannot see — rotated secret · external state · an infer output to re-roll)' -r
complete -c nika -n "__fish_nika_using_subcommand run" -l answer -d 'Answer a `nika:prompt` gate (repeatable · ADR-099 rider): binds as the named task\'s answer — `--answer ok=true` for confirm, a string for input, one of the choices for choice. The value parses as JSON when it parses, else rides as a string. Without `--resume` the answer is PRE-SEEDED on the fresh run: it waits in the gate map and is consumed when the task asks (the CI one-pass gate)' -r
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
complete -c nika -n "__fish_nika_using_subcommand run" -l resume-unverified -d 'Trust a `--resume` trace whose tamper-evidence chain FAILS the walk (ADR-099 trust amendment): the named opt-out, for a trace the operator edited or truncated by hand. The finding is journaled on the boot manifest (`resume_unverified: declared`) — never a silent default; a verified trace journals no claim'
complete -c nika -n "__fish_nika_using_subcommand run" -l no-trace-file -d 'Skip the run journal (`.nika/traces/<ts>-<id>.ndjson` · spec §3.3). Every run writes one by default so `nika trace show|replay`, `--resume` and the editor\'s runs view have a file to read. `NIKA_NO_TRACE_FILE` (any non-empty value) opts out globally'
complete -c nika -n "__fish_nika_using_subcommand run" -l no-outputs -d 'Hide the per-task output summaries (`→ {…} · 312B`) on the live storyboard. Interactive TTY only — pipes · CI · the machine modes never carry them anyway'
complete -c nika -n "__fish_nika_using_subcommand run" -l no-gc -d 'Skip the opportunistic trace collection for this invocation (ADR-100: `.nika/traces/` is bounded by default — retention rides every run start; a collection that removes anything says so on stderr)'
complete -c nika -n "__fish_nika_using_subcommand run" -l require-signature -d 'Refuse to run an unsigned or invalidly-signed workflow (exit 2 · checked BEFORE any task executes). OPT-IN — default is unsigned-tolerant'
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
complete -c nika -n "__fish_nika_using_subcommand inspect" -l format -d 'Project the graph instead of the human anatomy (json canonical · mermaid/dot derived — the docs/site surfaces)' -r -f -a "json\t'Canonical JSON projection (`graph_format: 3`)'
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
complete -c nika -n "__fish_nika_using_subcommand key; and not __fish_seen_subcommand_from init trust rotate help" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand key; and not __fish_seen_subcommand_from init trust rotate help" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand key; and not __fish_seen_subcommand_from init trust rotate help" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand key; and not __fish_seen_subcommand_from init trust rotate help" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand key; and not __fish_seen_subcommand_from init trust rotate help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand key; and not __fish_seen_subcommand_from init trust rotate help" -f -a "init" -d 'Mint the run-signing key (idempotent — refuses to clobber without `--force`)'
complete -c nika -n "__fish_nika_using_subcommand key; and not __fish_seen_subcommand_from init trust rotate help" -f -a "trust" -d 'Print the public key + TOFU fingerprint to enroll on other machines'
complete -c nika -n "__fish_nika_using_subcommand key; and not __fish_seen_subcommand_from init trust rotate help" -f -a "rotate" -d 'Retire the current public key to the ledger and mint a fresh one (old journals stay verifiable against the retired pubs)'
complete -c nika -n "__fish_nika_using_subcommand key; and not __fish_seen_subcommand_from init trust rotate help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c nika -n "__fish_nika_using_subcommand key; and __fish_seen_subcommand_from init" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand key; and __fish_seen_subcommand_from init" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand key; and __fish_seen_subcommand_from init" -l force -d 'Overwrite an existing key (a rotation without the retired-pub ledger entry)'
complete -c nika -n "__fish_nika_using_subcommand key; and __fish_seen_subcommand_from init" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand key; and __fish_seen_subcommand_from init" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand key; and __fish_seen_subcommand_from init" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand key; and __fish_seen_subcommand_from trust" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand key; and __fish_seen_subcommand_from trust" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand key; and __fish_seen_subcommand_from trust" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand key; and __fish_seen_subcommand_from trust" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand key; and __fish_seen_subcommand_from trust" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand key; and __fish_seen_subcommand_from rotate" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand key; and __fish_seen_subcommand_from rotate" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand key; and __fish_seen_subcommand_from rotate" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand key; and __fish_seen_subcommand_from rotate" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand key; and __fish_seen_subcommand_from rotate" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand key; and __fish_seen_subcommand_from help" -f -a "init" -d 'Mint the run-signing key (idempotent — refuses to clobber without `--force`)'
complete -c nika -n "__fish_nika_using_subcommand key; and __fish_seen_subcommand_from help" -f -a "trust" -d 'Print the public key + TOFU fingerprint to enroll on other machines'
complete -c nika -n "__fish_nika_using_subcommand key; and __fish_seen_subcommand_from help" -f -a "rotate" -d 'Retire the current public key to the ledger and mint a fresh one (old journals stay verifiable against the retired pubs)'
complete -c nika -n "__fish_nika_using_subcommand key; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c nika -n "__fish_nika_using_subcommand arm; and not __fish_seen_subcommand_from fire migrate disarm help" -l emit -d 'Emit the OS unit that fires the beats (`launchd` · `systemd`) instead of reading the registry — the W3 wave' -r -f -a "launchd\t'macOS launchd user agent (`~/Library/LaunchAgents/nika.arm.<radical>.plist`)'
systemd\t'A systemd user timer + service pair'"
complete -c nika -n "__fish_nika_using_subcommand arm; and not __fish_seen_subcommand_from fire migrate disarm help" -l out -d 'With `--emit --write`: the directory the unit writes to' -r -F
complete -c nika -n "__fish_nika_using_subcommand arm; and not __fish_seen_subcommand_from fire migrate disarm help" -l mode -d 'With `--emit`: the scope the unit installs at' -r -f -a "user\t'The operator\'s own agent (the default posture)'
system\t'A system-wide daemon'"
complete -c nika -n "__fish_nika_using_subcommand arm; and not __fish_seen_subcommand_from fire migrate disarm help" -l env-file -d 'With `--emit`: the env file the unit loads (provider keys live there, never in the unit)' -r -F
complete -c nika -n "__fish_nika_using_subcommand arm; and not __fish_seen_subcommand_from fire migrate disarm help" -l nika-bin -d 'With `--emit`: the nika binary the unit invokes' -r -F
complete -c nika -n "__fish_nika_using_subcommand arm; and not __fish_seen_subcommand_from fire migrate disarm help" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand arm; and not __fish_seen_subcommand_from fire migrate disarm help" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand arm; and not __fish_seen_subcommand_from fire migrate disarm help" -l write -d 'With `--emit`: write the unit file instead of printing it'
complete -c nika -n "__fish_nika_using_subcommand arm; and not __fish_seen_subcommand_from fire migrate disarm help" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand arm; and not __fish_seen_subcommand_from fire migrate disarm help" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand arm; and not __fish_seen_subcommand_from fire migrate disarm help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand arm; and not __fish_seen_subcommand_from fire migrate disarm help" -f -a "fire" -d 'Fire ONE beat now, if it is due — the one firer (D2): on-time window · miss policy · overlap lock · per-tick ceiling · the firing record. Prints exactly one stdout line, always (D8)'
complete -c nika -n "__fish_nika_using_subcommand arm; and not __fish_seen_subcommand_from fire migrate disarm help" -f -a "migrate" -d 'Explicitly upcast every W2 sidecar into the hash-chained ledger, verify each chain, and rebuild its projections. Idempotent and never silent: every beat receives a verdict'
complete -c nika -n "__fish_nika_using_subcommand arm; and not __fish_seen_subcommand_from fire migrate disarm help" -f -a "disarm" -d 'Teach the disarm gesture (law N4 — removing the line does NOT disarm; `actif: false` + `raison:` + `jusqu_au:` does)'
complete -c nika -n "__fish_nika_using_subcommand arm; and not __fish_seen_subcommand_from fire migrate disarm help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c nika -n "__fish_nika_using_subcommand arm; and __fish_seen_subcommand_from fire" -l now -d 'Inject the decision instant (RFC 3339) instead of reading the wall clock — the clock is the verb\'s edge (D5), so a replay and a test are deterministic' -r
complete -c nika -n "__fish_nika_using_subcommand arm; and __fish_seen_subcommand_from fire" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand arm; and __fish_seen_subcommand_from fire" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand arm; and __fish_seen_subcommand_from fire" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand arm; and __fish_seen_subcommand_from fire" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand arm; and __fish_seen_subcommand_from fire" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand arm; and __fish_seen_subcommand_from migrate" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand arm; and __fish_seen_subcommand_from migrate" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand arm; and __fish_seen_subcommand_from migrate" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand arm; and __fish_seen_subcommand_from migrate" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand arm; and __fish_seen_subcommand_from migrate" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand arm; and __fish_seen_subcommand_from disarm" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand arm; and __fish_seen_subcommand_from disarm" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand arm; and __fish_seen_subcommand_from disarm" -l write -d 'Also tear the OS unit down — the W3 wave'
complete -c nika -n "__fish_nika_using_subcommand arm; and __fish_seen_subcommand_from disarm" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand arm; and __fish_seen_subcommand_from disarm" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand arm; and __fish_seen_subcommand_from disarm" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand arm; and __fish_seen_subcommand_from help" -f -a "fire" -d 'Fire ONE beat now, if it is due — the one firer (D2): on-time window · miss policy · overlap lock · per-tick ceiling · the firing record. Prints exactly one stdout line, always (D8)'
complete -c nika -n "__fish_nika_using_subcommand arm; and __fish_seen_subcommand_from help" -f -a "migrate" -d 'Explicitly upcast every W2 sidecar into the hash-chained ledger, verify each chain, and rebuild its projections. Idempotent and never silent: every beat receives a verdict'
complete -c nika -n "__fish_nika_using_subcommand arm; and __fish_seen_subcommand_from help" -f -a "disarm" -d 'Teach the disarm gesture (law N4 — removing the line does NOT disarm; `actif: false` + `raison:` + `jusqu_au:` does)'
complete -c nika -n "__fish_nika_using_subcommand arm; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c nika -n "__fish_nika_using_subcommand serve" -l now -d 'Inject the clock (RFC 3339 · D5) — the harness' -r
complete -c nika -n "__fish_nika_using_subcommand serve" -l until -d 'Stop the loop at this instant (RFC 3339) — the harness' -r
complete -c nika -n "__fish_nika_using_subcommand serve" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand serve" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand serve" -l once -d 'Fire what is due once, then exit — the rehearsal'
complete -c nika -n "__fish_nika_using_subcommand serve" -l dry -d 'Say what WOULD fire, run nothing'
complete -c nika -n "__fish_nika_using_subcommand serve" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand serve" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand serve" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand sign" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand sign" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand sign" -l check -d 'Verify the `<file>.minisig` sidecar instead of minting it (exits: 0 valid · 2 FILE invalid/forged · 3 ENV missing/none)'
complete -c nika -n "__fish_nika_using_subcommand sign" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand sign" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand sign" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand doctor" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand doctor" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand doctor" -l ping -d 'TCP-probe the local provider ports (loopback/configured only · 300ms cap · nothing is sent on the socket). Offline without it'
complete -c nika -n "__fish_nika_using_subcommand doctor" -l json -d 'Emit the machine projection (summary + findings[] — agents/CI branch on `summary.fail` instead of parsing glyphs)'
complete -c nika -n "__fish_nika_using_subcommand doctor" -l verbose -d 'Unfold every advisory note (an unwired agent · an unconfigured provider · the config-less default) — the calm default folds them into ONE line (B-8b · a healthy machine reads calm)'
complete -c nika -n "__fish_nika_using_subcommand doctor" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand doctor" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand doctor" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand init" -l recipe -d 'Scaffold a workflow set — the wizard\'s recipe step, scriptable (`agentic` = the 4-pattern curriculum)' -r -f -a "agentic\t''
starter\t''
ship\t''
content\t''
minimal\t''"
complete -c nika -n "__fish_nika_using_subcommand init" -l example -d 'Found the project from ONE embedded example (verbatim — any slug from bare `nika try`). One founding source: conflicts with `--recipe`' -r
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
grok\t''
antigravity\t''
kimi\t''
kiro\t''
copilot\t''
amp\t''
detected\t'Only the clients THIS machine shows (the probe\'s presence truth) — the recommended door: `wire detected --dry-run`, then `wire detected`'
all\t'Every supported client — the advanced door: preview with `--dry-run`, confirm live on a terminal, or pass `--yes` in a pipe'"
complete -c nika -n "__fish_nika_using_subcommand init" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand init" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand init" -l force -d 'Overwrite existing files'
complete -c nika -n "__fish_nika_using_subcommand init" -s y -l yes -d 'Accept every default — never prompt (pipes and CI are implicitly `--yes`; prompts only ever appear on a terminal)'
complete -c nika -n "__fish_nika_using_subcommand init" -l project-file -d 'Lay a starter `nika.yaml` (the project file — ceiling + retention examples, commented so the starter governs nothing until you edit it). The ONLY scripted door; the wizard lane asks instead. An existing file is skipped, `--force` overrides'
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
complete -c nika -n "__fish_nika_using_subcommand wire" -l dry-run -d 'Print the per-client plan (created/updated/current/manual) — writes nothing'
complete -c nika -n "__fish_nika_using_subcommand wire" -l yes -d 'Consent to `all` without a prompt (scripts · CI — a terminal asks)'
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
complete -c nika -n "__fish_nika_using_subcommand try" -l model -d 'Run on a REAL seat instead of the default mock rehearsal (`<provider>/<name>` — the example\'s own `model:` via `self`)' -r
complete -c nika -n "__fish_nika_using_subcommand try" -l access -d 'Pin the ACCESS path for the rehearsal (a class — `local` · `api` · `harness` · `oauth` · `mock` — or an access id `nika doctor` lists). Unsatisfied refuses with a witness, never substitutes' -r
complete -c nika -n "__fish_nika_using_subcommand try" -l var -d 'Set a workflow `inputs:` value (repeatable)' -r
complete -c nika -n "__fish_nika_using_subcommand try" -l max-cost-usd -d 'Refuse to start if the static cost floor exceeds this (USD); metered spend aborts past it mid-run. Same guard, same parser as `nika run`' -r
complete -c nika -n "__fish_nika_using_subcommand try" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand try" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand try" -l all -d 'The whole shelf — the numbered path plus every job (bare `nika try` shows three familiar jobs first)'
complete -c nika -n "__fish_nika_using_subcommand try" -l quiet -d 'Verdict line only (suppress the storyboard)'
complete -c nika -n "__fish_nika_using_subcommand try" -l no-progress -d 'One final storyboard frame (no live repaints) — pipes/CI get this automatically'
complete -c nika -n "__fish_nika_using_subcommand try" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand try" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand try" -s h -l help -d 'Print help (see more with \'--help\')'
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
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay evidence receipt show ls rm outputs export verify anchor reproduce peek session flow help" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay evidence receipt show ls rm outputs export verify anchor reproduce peek session flow help" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay evidence receipt show ls rm outputs export verify anchor reproduce peek session flow help" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay evidence receipt show ls rm outputs export verify anchor reproduce peek session flow help" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay evidence receipt show ls rm outputs export verify anchor reproduce peek session flow help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay evidence receipt show ls rm outputs export verify anchor reproduce peek session flow help" -f -a "replay" -d 'Re-render a run live (replay = re-render, NEVER re-execute)'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay evidence receipt show ls rm outputs export verify anchor reproduce peek session flow help" -f -a "evidence" -d 'Export the evidence pack for one run (journal + manifest + receipt + VERIFY.md) — RAMS-15: one door on a run\'s dossier (read · export · prove), all under `trace`'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay evidence receipt show ls rm outputs export verify anchor reproduce peek session flow help" -f -a "receipt" -d 'Read a run receipt — `explain` renders its readable projection (stable text · a READING, never a proof)'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay evidence receipt show ls rm outputs export verify anchor reproduce peek session flow help" -f -a "show" -d 'Print the final card only'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay evidence receipt show ls rm outputs export verify anchor reproduce peek session flow help" -f -a "ls" -d 'List the workspace trace store (`.nika/traces/`): age · size · workflow · terminal state (completed/failed/paused) · the resume-candidate marker (★ — the newest of each workflow, the trace retention never collects · ADR-100)'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay evidence receipt show ls rm outputs export verify anchor reproduce peek session flow help" -f -a "rm" -d 'Remove traces from the store — one by name/path, `--older-than <dur>`, or `--all`. Removing a paused trace refuses without `--force` and names the unanswered prompt it would destroy (ADR-100)'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay evidence receipt show ls rm outputs export verify anchor reproduce peek session flow help" -f -a "outputs" -d 'Browse per-task outputs: verb · duration · tokens · bounded preview (full value: `trace peek`)'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay evidence receipt show ls rm outputs export verify anchor reproduce peek session flow help" -f -a "export" -d 'Project the journal to OTLP/JSON lines — every `OTel` tool becomes a viewer (drag into Jaeger UI ≥1.60 · POST lines to any OTLP/HTTP endpoint). Local file, zero collector, zero vendor'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay evidence receipt show ls rm outputs export verify anchor reproduce peek session flow help" -f -a "verify" -d 'Verify the journal\'s tamper-evidence chain (0.96+), then climb the proof ladder: SEALED (the `run_sealed` signature verifies against a custody key) · ANCHORED (the `<trace>.anchor.json` sidecar verifies fully offline) · REPLAYED (--replay compares a fresh run). The HIGHEST honestly-attained tier is reported. Three refusals name themselves rather than hide in a tier: TAMPERED · SEAL BURIED (lines chained AFTER the seal — appending needs only write access, so this is forgery, never a crash) · ANCHOR FORGED (a sidecar that vouches for nothing) · and SEAL UNATTRIBUTABLE (the seal names a key you do not hold: the signature is NOT judged, which is a missing input and never evidence of forgery). Exit 0 the tier holds · 2 broken chain, forged seal or forged anchor · 3 unchained (pre-chain journal), a missing input, or a seal this host cannot attribute'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay evidence receipt show ls rm outputs export verify anchor reproduce peek session flow help" -f -a "anchor" -d 'Notarize the journal head OUTSIDE the journal (S3): submit the post-seal head — signed with the run key — to the public Sigstore Rekor v2 transparency log plus an RFC 3161 timestamp, writing a detached `<trace>.anchor.json` sidecar. An explicit NETWORK act: this verb IS the opt-in. Exit 0 anchored · 2 the journal refuses (broken/torn) · 3 no key/network'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay evidence receipt show ls rm outputs export verify anchor reproduce peek session flow help" -f -a "reproduce" -d 'Is this run reproducible? Compare a recorded journal against a fresh one and classify every task: reproduced · nondeterministic (same def+inputs, different output) · authored · environment · status-changed · unverifiable. Exit 0 reproduced · 2 diverged'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay evidence receipt show ls rm outputs export verify anchor reproduce peek session flow help" -f -a "peek" -d 'Read ONE task\'s full output + its identity (hashes · duration · tokens). `--raw` prints the exact value only (pipe it to jq)'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay evidence receipt show ls rm outputs export verify anchor reproduce peek session flow help" -f -a "session" -d 'The session digest: waves · the wave holder others waited for · the spend by verb · the wall. The four numbers `nika-tui-core` derives — every one of them gated by the predicate that says whether it may be claimed (a holder nobody waited for is not named; no holder is painted over a failure)'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay evidence receipt show ls rm outputs export verify anchor reproduce peek session flow help" -f -a "flow" -d 'The data waterfall: which output fed which task, with recorded sizes (plan bindings from the workflow file × sizes from the trace)'
complete -c nika -n "__fish_nika_using_subcommand trace; and not __fish_seen_subcommand_from replay evidence receipt show ls rm outputs export verify anchor reproduce peek session flow help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
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
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from evidence" -s o -l out -d 'Output directory (default: `<trace-stem>.evidence/` · never clobbered)' -r -F
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from evidence" -l workflow -d 'The workflow file that ran — hash-checked; unlocks the boundary, the trifecta verdict and the receipt' -r
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from evidence" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from evidence" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from evidence" -l json -d 'Print the pack manifest to stdout (no directory written)'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from evidence" -l full -d 'Carry the run\'s CONTENT verbatim (model outputs · tool results · file reads). Default: the redacted pack — it proves the run\'s INTEGRITY, not its CONTENT; disclosure stays operator-side'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from evidence" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from evidence" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from evidence" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from receipt" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from receipt" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from receipt" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from receipt" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from receipt" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from receipt" -f -a "explain" -d 'Render a receipt\'s readable projection (stable text · a READING, never a proof — `verify` owns the proof)'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from receipt" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
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
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from verify" -l key -d 'A candidate run public key for the SEALED tier (default: ~/.nika/keys/run-signing.pub, then the retired.pub ledger)' -r -F
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from verify" -l replay -d 'The REPLAYED tier: a FRESH journal of the same workflow to compare against (verify never re-executes)' -r -F
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from verify" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from verify" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from verify" -l anchored -d 'Require the anchor tier: a MISSING sidecar is exit 3 (a forged one is exit 2 either way)'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from verify" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from verify" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from verify" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from anchor" -l rekor-url -d 'The Rekor v2 shard. A private rekor-tiles deployment works, but its checkpoint is not the pinned Sigstore key\'s — the ANCHORED verify tier stays out of reach there' -r
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from anchor" -l tsa-url -d 'The RFC 3161 timestamp authority. The token verifies against the pinned Sigstore TSA leaf — mirrors of that TSA work, other authorities fail closed' -r
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from anchor" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from anchor" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from anchor" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from anchor" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from anchor" -s h -l help -d 'Print help (see more with \'--help\')'
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
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from session" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from session" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from session" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from session" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from session" -s h -l help -d 'Print help (see more with \'--help\')'
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
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "evidence" -d 'Export the evidence pack for one run (journal + manifest + receipt + VERIFY.md) — RAMS-15: one door on a run\'s dossier (read · export · prove), all under `trace`'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "receipt" -d 'Read a run receipt — `explain` renders its readable projection (stable text · a READING, never a proof)'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "show" -d 'Print the final card only'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "ls" -d 'List the workspace trace store (`.nika/traces/`): age · size · workflow · terminal state (completed/failed/paused) · the resume-candidate marker (★ — the newest of each workflow, the trace retention never collects · ADR-100)'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "rm" -d 'Remove traces from the store — one by name/path, `--older-than <dur>`, or `--all`. Removing a paused trace refuses without `--force` and names the unanswered prompt it would destroy (ADR-100)'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "outputs" -d 'Browse per-task outputs: verb · duration · tokens · bounded preview (full value: `trace peek`)'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "export" -d 'Project the journal to OTLP/JSON lines — every `OTel` tool becomes a viewer (drag into Jaeger UI ≥1.60 · POST lines to any OTLP/HTTP endpoint). Local file, zero collector, zero vendor'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "verify" -d 'Verify the journal\'s tamper-evidence chain (0.96+), then climb the proof ladder: SEALED (the `run_sealed` signature verifies against a custody key) · ANCHORED (the `<trace>.anchor.json` sidecar verifies fully offline) · REPLAYED (--replay compares a fresh run). The HIGHEST honestly-attained tier is reported. Three refusals name themselves rather than hide in a tier: TAMPERED · SEAL BURIED (lines chained AFTER the seal — appending needs only write access, so this is forgery, never a crash) · ANCHOR FORGED (a sidecar that vouches for nothing) · and SEAL UNATTRIBUTABLE (the seal names a key you do not hold: the signature is NOT judged, which is a missing input and never evidence of forgery). Exit 0 the tier holds · 2 broken chain, forged seal or forged anchor · 3 unchained (pre-chain journal), a missing input, or a seal this host cannot attribute'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "anchor" -d 'Notarize the journal head OUTSIDE the journal (S3): submit the post-seal head — signed with the run key — to the public Sigstore Rekor v2 transparency log plus an RFC 3161 timestamp, writing a detached `<trace>.anchor.json` sidecar. An explicit NETWORK act: this verb IS the opt-in. Exit 0 anchored · 2 the journal refuses (broken/torn) · 3 no key/network'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "reproduce" -d 'Is this run reproducible? Compare a recorded journal against a fresh one and classify every task: reproduced · nondeterministic (same def+inputs, different output) · authored · environment · status-changed · unverifiable. Exit 0 reproduced · 2 diverged'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "peek" -d 'Read ONE task\'s full output + its identity (hashes · duration · tokens). `--raw` prints the exact value only (pipe it to jq)'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "session" -d 'The session digest: waves · the wave holder others waited for · the spend by verb · the wall. The four numbers `nika-tui-core` derives — every one of them gated by the predicate that says whether it may be claimed (a holder nobody waited for is not named; no holder is painted over a failure)'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "flow" -d 'The data waterfall: which output fed which task, with recorded sizes (plan bindings from the workflow file × sizes from the trace)'
complete -c nika -n "__fish_nika_using_subcommand trace; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c nika -n "__fish_nika_using_subcommand guard" -l command -d 'Judge ONE shell command line instead of a hook payload' -r
complete -c nika -n "__fish_nika_using_subcommand guard" -l cwd -d 'The directory the command runs in (with `--command`; the payload\'s `cwd` wins on the stdin wire, the process cwd otherwise)' -r
complete -c nika -n "__fish_nika_using_subcommand guard" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand guard" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand guard" -l stdin -d 'Read the host hook JSON payload from stdin (the shim\'s wire: Cursor `{command, cwd}` · Claude Code `PreToolUse` `{tool_input:{command}, cwd}` — sniffed by `hook_event_name`)'
complete -c nika -n "__fish_nika_using_subcommand guard" -l human -d 'The human reading (allow · deny · `guard_unavailable` + why) instead of the hook JSON protocol'
complete -c nika -n "__fish_nika_using_subcommand guard" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand guard" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand guard" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand dap" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand dap" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand dap" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand dap" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand dap" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand lsp" -l clientProcessId -d 'Same convention family: hosts pass their own PID so a server can watchdog its parent. Accepted, currently unread' -r
complete -c nika -n "__fish_nika_using_subcommand lsp" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand lsp" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand lsp" -l stdio -d 'LSP-host convention flag: vscode-languageclient, nvim and helix spawn `<server> --stdio` by habit. Stdio is this server\'s ONLY transport, so the flag is a no-op — but refusing it killed every spawn from a client that passes it, with exit 2 before the first byte of JSON-RPC (the v0.106.0 extension post-mortem: the language server had never once run in production because of this refusal). Hidden: it teaches nothing a human needs to type'
complete -c nika -n "__fish_nika_using_subcommand lsp" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand lsp" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand lsp" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand mcp; and not __fish_seen_subcommand_from approve help" -l transport -d 'The wire: `stdio` (the editor/agent default) or `http` (Streamable HTTP · POST JSON-RPC · spec 2025-11-25)' -r -f -a "stdio\t'Newline-delimited JSON-RPC over stdin/stdout'
http\t'Streamable HTTP (POST JSON-RPC · origin-gated · loopback default)'"
complete -c nika -n "__fish_nika_using_subcommand mcp; and not __fish_seen_subcommand_from approve help" -l port -d 'HTTP port (with `--transport http`)' -r
complete -c nika -n "__fish_nika_using_subcommand mcp; and not __fish_seen_subcommand_from approve help" -l bind -d 'HTTP bind address. Loopback by default — widening this exposes the server to your network; put TLS + auth (a reverse proxy · `NIKA_MCP_TOKEN`) in front before you do' -r
complete -c nika -n "__fish_nika_using_subcommand mcp; and not __fish_seen_subcommand_from approve help" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand mcp; and not __fish_seen_subcommand_from approve help" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand mcp; and not __fish_seen_subcommand_from approve help" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand mcp; and not __fish_seen_subcommand_from approve help" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand mcp; and not __fish_seen_subcommand_from approve help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand mcp; and not __fish_seen_subcommand_from approve help" -f -a "approve" -d 'Re-pin the server\'s CURRENT tool definitions after human review (the remediation a drift refusal names), printing the new pin set'
complete -c nika -n "__fish_nika_using_subcommand mcp; and not __fish_seen_subcommand_from approve help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c nika -n "__fish_nika_using_subcommand mcp; and __fish_seen_subcommand_from approve" -l color -d 'When to colour the output (auto = TTY + `TERM != dumb` · honours `CLICOLOR_FORCE` · `NO_COLOR` · `CLICOLOR=0` in that order)' -r -f -a "always\t'Force colour on (pagers accepting escapes · captured demos)'
never\t'Force colour off (the `--no-color` flags fold here)'
auto\t'Resolve from the environment chain + TTY (the default)'"
complete -c nika -n "__fish_nika_using_subcommand mcp; and __fish_seen_subcommand_from approve" -l hyperlink -d 'When to emit OSC-8 hyperlinks on printed paths (auto = TTY + `TERM != dumb` · never to pipes; always = force them, for pagers that pass escapes — tmux/screen may render them as plain text)' -r -f -a "always\t'Force hyperlinks on (escape-passing pagers · captured demos)'
never\t'Force hyperlinks off'
auto\t'TTY + `TERM != dumb` — never to pipes (the default)'"
complete -c nika -n "__fish_nika_using_subcommand mcp; and __fish_seen_subcommand_from approve" -l ascii -d 'Force the ASCII glyph twins everywhere (CI logs · legacy terminals) — colour stays; `--plain` is the full sober umbrella'
complete -c nika -n "__fish_nika_using_subcommand mcp; and __fish_seen_subcommand_from approve" -l plain -d 'The sober umbrella — one flag for scripts, CI and transcripts: colour off · ASCII glyphs · hyperlinks off · no animation (`run` renders its plain storyboard). The same result as `--color never --hyperlink never` plus every verb\'s `--ascii`/`--no-progress`'
complete -c nika -n "__fish_nika_using_subcommand mcp; and __fish_seen_subcommand_from approve" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c nika -n "__fish_nika_using_subcommand mcp; and __fish_seen_subcommand_from help" -f -a "approve" -d 'Re-pin the server\'s CURRENT tool definitions after human review (the remediation a drift refusal names), printing the new pin set'
complete -c nika -n "__fish_nika_using_subcommand mcp; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "list" -d 'List the workflows below this directory, one relative path per line'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "welcome" -d 'The mirror: what Nika is · what this machine already has (editors · local models · key presence · this workspace) · the next commands. Offline · presence-only · always exit 0 — a greeting, not a gate'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "check" -d 'Audit a workflow BEFORE it runs: plan · cost ceiling · secret flows · types · tools — every finding teaches its fix'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "run" -d 'Run a workflow (the same audit runs first · live render)'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "test" -d 'Golden test: run under the MOCK provider (offline · deterministic) and compare the typed `outputs:` against `<file>.golden.json`'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "inspect" -d 'Static anatomy: tasks · verbs · wave groups · cost · permits — and the ONE graph projector (`--format json|mermaid|dot` for the machine surfaces · human stays the default)'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "explain" -d 'Teach one error code (cause · category · fix-form) — or narrate a workflow FILE: what it does · the waves · cost before a token is spent · what it touches · how to run it'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "key" -d 'The run-signing key lifecycle (mint · TOFU fingerprint · rotate — old pubs stay verifiable)'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "arm" -d 'What this project has ARMED, and when each beat next fires. Read-only — it schedules nothing (the file proposes, the machine disposes). Exit `0` clean · `2` the registry refuses'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "serve" -d 'The resident firer: the SAME `fire`, the wall clock in place of the OS (W5). Exit `0` clean · `1` otherwise'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "sign" -d 'Sign a workflow file (S3 · author-binding): mint `<file>.minisig` · `--check` verifies'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "doctor" -d 'Diagnose this machine (binary · config · provider keys · local models). Diagnose-only — prints the exact fix command, never mutates anything'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "init" -d 'Found a repo (`.vscode` schema wiring · `AGENTS.md` · Cursor rule + MCP · `.agents/skills` authoring skill · optional workflow set). Bare on a terminal the founding wizard runs; flags are the scriptable twin. Existing files are skipped — `--force` overwrites'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "wire" -d 'Wire Nika into editor/agent MCP clients (explicit, idempotent). The door: `detected --dry-run` previews what this machine shows · `detected` wires it · `<client>` wires one · `all` is the advanced sweep (previewed, then confirmed or `--yes`)'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "model" -d 'Local models — pull from the Hugging Face Hub, serve on this machine, list/rm the disk (ONE models dir · no external daemon)'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "spec" -d 'The embedded spec identity (`--canon` prints the SSOT)'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "catalog" -d 'The embedded provider/model catalog (models · capabilities · env vars)'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "try" -d 'See a canonical workflow WORK — offline by default (the mock rehearsal · zero keys · zero flags), nothing written, nothing owned. Bare `nika try` lists what there is to see'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "new" -d 'The ONE creation door: describe the job in plain words (routes), or name a slug/skeleton (takes it, ingredients included) — the destination derives from the slug. Plain words route across jobs, lessons and skeletons. Bare `nika new` on a terminal is the guided flow; `nika new \'?\'` lists the skeleton set'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "completions" -d 'Generate shell completions (bash · zsh · fish · elvish · powershell)'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "trace" -d 'Read the flight recorder (replay or summarize a run)'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "guard" -d 'The hook\'s judge (hidden — the wired `guard-run.sh` shim calls it, agents never type it): read a host hook payload (`--stdin`) or one command line (`--command`), find every effective `nika run`, audit the EXACT file in-process, and answer the hook protocol. P0-7 + P0-15: a red file or a priced model without `--max-cost-usd` is denied; an unjudgeable run is a VISIBLE `guard_unavailable`, never a silent allow. The run belongs to the human — guard JUDGES, it never executes'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "dap" -d 'Debug Adapter Protocol server (stdio) — time-travel a recorded run under a debugger UI: breakpoints on task lines · step forward AND back through settles · outputs in the variables pane. Replay re-renders, never re-executes'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "lsp" -d 'Run the language server over stdio (drives the editor extension)'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "mcp" -d 'Run the MCP server (validate: check/explain · learn: schema/examples/templates/canon — the in-binary Model Context Protocol surface for Cursor · Claude Desktop · agents). Default transport: stdio; `--transport http` serves Streamable HTTP for managed hosts. `approve` runs the CLIENT side: the MCP tool-pinning re-approval over the servers configured in `.nika/mcp_servers.json`'
complete -c nika -n "__fish_nika_using_subcommand help; and not __fish_seen_subcommand_from list welcome check run test inspect explain key arm serve sign doctor init wire model spec catalog try new completions trace guard dap lsp mcp help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from key" -f -a "init" -d 'Mint the run-signing key (idempotent — refuses to clobber without `--force`)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from key" -f -a "trust" -d 'Print the public key + TOFU fingerprint to enroll on other machines'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from key" -f -a "rotate" -d 'Retire the current public key to the ledger and mint a fresh one (old journals stay verifiable against the retired pubs)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from arm" -f -a "fire" -d 'Fire ONE beat now, if it is due — the one firer (D2): on-time window · miss policy · overlap lock · per-tick ceiling · the firing record. Prints exactly one stdout line, always (D8)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from arm" -f -a "migrate" -d 'Explicitly upcast every W2 sidecar into the hash-chained ledger, verify each chain, and rebuild its projections. Idempotent and never silent: every beat receives a verdict'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from arm" -f -a "disarm" -d 'Teach the disarm gesture (law N4 — removing the line does NOT disarm; `actif: false` + `raison:` + `jusqu_au:` does)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from model" -f -a "serve" -d 'Serve a GGUF model — an OpenAI-compatible foreground server on 127.0.0.1 (Ctrl-C stops it · the banner says how workflows reach it)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from model" -f -a "pull" -d 'Download a GGUF from the Hugging Face Hub into the ONE models dir (`~/.nika/models` — the same dir `serve --model <id>` resolves, by construction). Size prints BEFORE downloading; 2 GiB and over confirms (`--yes` for CI). An interrupted pull resumes from its `.part`. `HF_TOKEN` authenticates gated repos. This fetch is CLI-level, like `registry:` pulls — a workflow\'s `permits:` never govern it'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from model" -f -a "list" -d 'What\'s on disk: id · size · file per GGUF — the ONE models dir printed once at top'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from model" -f -a "rm" -d 'Remove a pulled model: `owner/repo` removes every quant (and the tokenizer beside them) · `owner/repo:QUANT` one file. A no-match refuses, listing what IS there'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "replay" -d 'Re-render a run live (replay = re-render, NEVER re-execute)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "evidence" -d 'Export the evidence pack for one run (journal + manifest + receipt + VERIFY.md) — RAMS-15: one door on a run\'s dossier (read · export · prove), all under `trace`'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "receipt" -d 'Read a run receipt — `explain` renders its readable projection (stable text · a READING, never a proof)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "show" -d 'Print the final card only'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "ls" -d 'List the workspace trace store (`.nika/traces/`): age · size · workflow · terminal state (completed/failed/paused) · the resume-candidate marker (★ — the newest of each workflow, the trace retention never collects · ADR-100)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "rm" -d 'Remove traces from the store — one by name/path, `--older-than <dur>`, or `--all`. Removing a paused trace refuses without `--force` and names the unanswered prompt it would destroy (ADR-100)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "outputs" -d 'Browse per-task outputs: verb · duration · tokens · bounded preview (full value: `trace peek`)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "export" -d 'Project the journal to OTLP/JSON lines — every `OTel` tool becomes a viewer (drag into Jaeger UI ≥1.60 · POST lines to any OTLP/HTTP endpoint). Local file, zero collector, zero vendor'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "verify" -d 'Verify the journal\'s tamper-evidence chain (0.96+), then climb the proof ladder: SEALED (the `run_sealed` signature verifies against a custody key) · ANCHORED (the `<trace>.anchor.json` sidecar verifies fully offline) · REPLAYED (--replay compares a fresh run). The HIGHEST honestly-attained tier is reported. Three refusals name themselves rather than hide in a tier: TAMPERED · SEAL BURIED (lines chained AFTER the seal — appending needs only write access, so this is forgery, never a crash) · ANCHOR FORGED (a sidecar that vouches for nothing) · and SEAL UNATTRIBUTABLE (the seal names a key you do not hold: the signature is NOT judged, which is a missing input and never evidence of forgery). Exit 0 the tier holds · 2 broken chain, forged seal or forged anchor · 3 unchained (pre-chain journal), a missing input, or a seal this host cannot attribute'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "anchor" -d 'Notarize the journal head OUTSIDE the journal (S3): submit the post-seal head — signed with the run key — to the public Sigstore Rekor v2 transparency log plus an RFC 3161 timestamp, writing a detached `<trace>.anchor.json` sidecar. An explicit NETWORK act: this verb IS the opt-in. Exit 0 anchored · 2 the journal refuses (broken/torn) · 3 no key/network'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "reproduce" -d 'Is this run reproducible? Compare a recorded journal against a fresh one and classify every task: reproduced · nondeterministic (same def+inputs, different output) · authored · environment · status-changed · unverifiable. Exit 0 reproduced · 2 diverged'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "peek" -d 'Read ONE task\'s full output + its identity (hashes · duration · tokens). `--raw` prints the exact value only (pipe it to jq)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "session" -d 'The session digest: waves · the wave holder others waited for · the spend by verb · the wall. The four numbers `nika-tui-core` derives — every one of them gated by the predicate that says whether it may be claimed (a holder nobody waited for is not named; no holder is painted over a failure)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from trace" -f -a "flow" -d 'The data waterfall: which output fed which task, with recorded sizes (plan bindings from the workflow file × sizes from the trace)'
complete -c nika -n "__fish_nika_using_subcommand help; and __fish_seen_subcommand_from mcp" -f -a "approve" -d 'Re-pin the server\'s CURRENT tool definitions after human review (the remediation a drift refusal names), printing the new pin set'
