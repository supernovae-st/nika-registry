_nika() {
    local i cur prev opts cmd
    COMPREPLY=()
    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
        cur="$2"
    else
        cur="${COMP_WORDS[COMP_CWORD]}"
    fi
    prev="$3"
    cmd=""
    opts=""

    for i in "${COMP_WORDS[@]:0:COMP_CWORD}"
    do
        case "${cmd},${i}" in
            ",$1")
                cmd="nika"
                ;;
            nika,catalog)
                cmd="nika__subcmd__catalog"
                ;;
            nika,check)
                cmd="nika__subcmd__check"
                ;;
            nika,completions)
                cmd="nika__subcmd__completions"
                ;;
            nika,dap)
                cmd="nika__subcmd__dap"
                ;;
            nika,doctor)
                cmd="nika__subcmd__doctor"
                ;;
            nika,examples)
                cmd="nika__subcmd__examples"
                ;;
            nika,explain)
                cmd="nika__subcmd__explain"
                ;;
            nika,help)
                cmd="nika__subcmd__help"
                ;;
            nika,init)
                cmd="nika__subcmd__init"
                ;;
            nika,inspect)
                cmd="nika__subcmd__inspect"
                ;;
            nika,lsp)
                cmd="nika__subcmd__lsp"
                ;;
            nika,mcp)
                cmd="nika__subcmd__mcp"
                ;;
            nika,model)
                cmd="nika__subcmd__model"
                ;;
            nika,new)
                cmd="nika__subcmd__new"
                ;;
            nika,run)
                cmd="nika__subcmd__run"
                ;;
            nika,spec)
                cmd="nika__subcmd__spec"
                ;;
            nika,test)
                cmd="nika__subcmd__test"
                ;;
            nika,trace)
                cmd="nika__subcmd__trace"
                ;;
            nika,welcome)
                cmd="nika__subcmd__welcome"
                ;;
            nika,wire)
                cmd="nika__subcmd__wire"
                ;;
            nika__subcmd__examples,copy)
                cmd="nika__subcmd__examples__subcmd__copy"
                ;;
            nika__subcmd__examples,help)
                cmd="nika__subcmd__examples__subcmd__help"
                ;;
            nika__subcmd__examples,list)
                cmd="nika__subcmd__examples__subcmd__list"
                ;;
            nika__subcmd__examples,run)
                cmd="nika__subcmd__examples__subcmd__run"
                ;;
            nika__subcmd__examples,show)
                cmd="nika__subcmd__examples__subcmd__show"
                ;;
            nika__subcmd__examples__subcmd__help,copy)
                cmd="nika__subcmd__examples__subcmd__help__subcmd__copy"
                ;;
            nika__subcmd__examples__subcmd__help,help)
                cmd="nika__subcmd__examples__subcmd__help__subcmd__help"
                ;;
            nika__subcmd__examples__subcmd__help,list)
                cmd="nika__subcmd__examples__subcmd__help__subcmd__list"
                ;;
            nika__subcmd__examples__subcmd__help,run)
                cmd="nika__subcmd__examples__subcmd__help__subcmd__run"
                ;;
            nika__subcmd__examples__subcmd__help,show)
                cmd="nika__subcmd__examples__subcmd__help__subcmd__show"
                ;;
            nika__subcmd__help,catalog)
                cmd="nika__subcmd__help__subcmd__catalog"
                ;;
            nika__subcmd__help,check)
                cmd="nika__subcmd__help__subcmd__check"
                ;;
            nika__subcmd__help,completions)
                cmd="nika__subcmd__help__subcmd__completions"
                ;;
            nika__subcmd__help,dap)
                cmd="nika__subcmd__help__subcmd__dap"
                ;;
            nika__subcmd__help,doctor)
                cmd="nika__subcmd__help__subcmd__doctor"
                ;;
            nika__subcmd__help,examples)
                cmd="nika__subcmd__help__subcmd__examples"
                ;;
            nika__subcmd__help,explain)
                cmd="nika__subcmd__help__subcmd__explain"
                ;;
            nika__subcmd__help,help)
                cmd="nika__subcmd__help__subcmd__help"
                ;;
            nika__subcmd__help,init)
                cmd="nika__subcmd__help__subcmd__init"
                ;;
            nika__subcmd__help,inspect)
                cmd="nika__subcmd__help__subcmd__inspect"
                ;;
            nika__subcmd__help,lsp)
                cmd="nika__subcmd__help__subcmd__lsp"
                ;;
            nika__subcmd__help,mcp)
                cmd="nika__subcmd__help__subcmd__mcp"
                ;;
            nika__subcmd__help,model)
                cmd="nika__subcmd__help__subcmd__model"
                ;;
            nika__subcmd__help,new)
                cmd="nika__subcmd__help__subcmd__new"
                ;;
            nika__subcmd__help,run)
                cmd="nika__subcmd__help__subcmd__run"
                ;;
            nika__subcmd__help,spec)
                cmd="nika__subcmd__help__subcmd__spec"
                ;;
            nika__subcmd__help,test)
                cmd="nika__subcmd__help__subcmd__test"
                ;;
            nika__subcmd__help,trace)
                cmd="nika__subcmd__help__subcmd__trace"
                ;;
            nika__subcmd__help,welcome)
                cmd="nika__subcmd__help__subcmd__welcome"
                ;;
            nika__subcmd__help,wire)
                cmd="nika__subcmd__help__subcmd__wire"
                ;;
            nika__subcmd__help__subcmd__examples,copy)
                cmd="nika__subcmd__help__subcmd__examples__subcmd__copy"
                ;;
            nika__subcmd__help__subcmd__examples,list)
                cmd="nika__subcmd__help__subcmd__examples__subcmd__list"
                ;;
            nika__subcmd__help__subcmd__examples,run)
                cmd="nika__subcmd__help__subcmd__examples__subcmd__run"
                ;;
            nika__subcmd__help__subcmd__examples,show)
                cmd="nika__subcmd__help__subcmd__examples__subcmd__show"
                ;;
            nika__subcmd__help__subcmd__model,list)
                cmd="nika__subcmd__help__subcmd__model__subcmd__list"
                ;;
            nika__subcmd__help__subcmd__model,pull)
                cmd="nika__subcmd__help__subcmd__model__subcmd__pull"
                ;;
            nika__subcmd__help__subcmd__model,rm)
                cmd="nika__subcmd__help__subcmd__model__subcmd__rm"
                ;;
            nika__subcmd__help__subcmd__model,serve)
                cmd="nika__subcmd__help__subcmd__model__subcmd__serve"
                ;;
            nika__subcmd__help__subcmd__trace,export)
                cmd="nika__subcmd__help__subcmd__trace__subcmd__export"
                ;;
            nika__subcmd__help__subcmd__trace,flow)
                cmd="nika__subcmd__help__subcmd__trace__subcmd__flow"
                ;;
            nika__subcmd__help__subcmd__trace,ls)
                cmd="nika__subcmd__help__subcmd__trace__subcmd__ls"
                ;;
            nika__subcmd__help__subcmd__trace,outputs)
                cmd="nika__subcmd__help__subcmd__trace__subcmd__outputs"
                ;;
            nika__subcmd__help__subcmd__trace,peek)
                cmd="nika__subcmd__help__subcmd__trace__subcmd__peek"
                ;;
            nika__subcmd__help__subcmd__trace,replay)
                cmd="nika__subcmd__help__subcmd__trace__subcmd__replay"
                ;;
            nika__subcmd__help__subcmd__trace,reproduce)
                cmd="nika__subcmd__help__subcmd__trace__subcmd__reproduce"
                ;;
            nika__subcmd__help__subcmd__trace,rm)
                cmd="nika__subcmd__help__subcmd__trace__subcmd__rm"
                ;;
            nika__subcmd__help__subcmd__trace,show)
                cmd="nika__subcmd__help__subcmd__trace__subcmd__show"
                ;;
            nika__subcmd__help__subcmd__trace,verify)
                cmd="nika__subcmd__help__subcmd__trace__subcmd__verify"
                ;;
            nika__subcmd__model,help)
                cmd="nika__subcmd__model__subcmd__help"
                ;;
            nika__subcmd__model,list)
                cmd="nika__subcmd__model__subcmd__list"
                ;;
            nika__subcmd__model,pull)
                cmd="nika__subcmd__model__subcmd__pull"
                ;;
            nika__subcmd__model,rm)
                cmd="nika__subcmd__model__subcmd__rm"
                ;;
            nika__subcmd__model,serve)
                cmd="nika__subcmd__model__subcmd__serve"
                ;;
            nika__subcmd__model__subcmd__help,help)
                cmd="nika__subcmd__model__subcmd__help__subcmd__help"
                ;;
            nika__subcmd__model__subcmd__help,list)
                cmd="nika__subcmd__model__subcmd__help__subcmd__list"
                ;;
            nika__subcmd__model__subcmd__help,pull)
                cmd="nika__subcmd__model__subcmd__help__subcmd__pull"
                ;;
            nika__subcmd__model__subcmd__help,rm)
                cmd="nika__subcmd__model__subcmd__help__subcmd__rm"
                ;;
            nika__subcmd__model__subcmd__help,serve)
                cmd="nika__subcmd__model__subcmd__help__subcmd__serve"
                ;;
            nika__subcmd__trace,export)
                cmd="nika__subcmd__trace__subcmd__export"
                ;;
            nika__subcmd__trace,flow)
                cmd="nika__subcmd__trace__subcmd__flow"
                ;;
            nika__subcmd__trace,help)
                cmd="nika__subcmd__trace__subcmd__help"
                ;;
            nika__subcmd__trace,ls)
                cmd="nika__subcmd__trace__subcmd__ls"
                ;;
            nika__subcmd__trace,outputs)
                cmd="nika__subcmd__trace__subcmd__outputs"
                ;;
            nika__subcmd__trace,peek)
                cmd="nika__subcmd__trace__subcmd__peek"
                ;;
            nika__subcmd__trace,replay)
                cmd="nika__subcmd__trace__subcmd__replay"
                ;;
            nika__subcmd__trace,reproduce)
                cmd="nika__subcmd__trace__subcmd__reproduce"
                ;;
            nika__subcmd__trace,rm)
                cmd="nika__subcmd__trace__subcmd__rm"
                ;;
            nika__subcmd__trace,show)
                cmd="nika__subcmd__trace__subcmd__show"
                ;;
            nika__subcmd__trace,verify)
                cmd="nika__subcmd__trace__subcmd__verify"
                ;;
            nika__subcmd__trace__subcmd__help,export)
                cmd="nika__subcmd__trace__subcmd__help__subcmd__export"
                ;;
            nika__subcmd__trace__subcmd__help,flow)
                cmd="nika__subcmd__trace__subcmd__help__subcmd__flow"
                ;;
            nika__subcmd__trace__subcmd__help,help)
                cmd="nika__subcmd__trace__subcmd__help__subcmd__help"
                ;;
            nika__subcmd__trace__subcmd__help,ls)
                cmd="nika__subcmd__trace__subcmd__help__subcmd__ls"
                ;;
            nika__subcmd__trace__subcmd__help,outputs)
                cmd="nika__subcmd__trace__subcmd__help__subcmd__outputs"
                ;;
            nika__subcmd__trace__subcmd__help,peek)
                cmd="nika__subcmd__trace__subcmd__help__subcmd__peek"
                ;;
            nika__subcmd__trace__subcmd__help,replay)
                cmd="nika__subcmd__trace__subcmd__help__subcmd__replay"
                ;;
            nika__subcmd__trace__subcmd__help,reproduce)
                cmd="nika__subcmd__trace__subcmd__help__subcmd__reproduce"
                ;;
            nika__subcmd__trace__subcmd__help,rm)
                cmd="nika__subcmd__trace__subcmd__help__subcmd__rm"
                ;;
            nika__subcmd__trace__subcmd__help,show)
                cmd="nika__subcmd__trace__subcmd__help__subcmd__show"
                ;;
            nika__subcmd__trace__subcmd__help,verify)
                cmd="nika__subcmd__trace__subcmd__help__subcmd__verify"
                ;;
            *)
                ;;
        esac
    done

    case "${cmd}" in
        nika)
            opts="-h -V --color --hyperlink --ascii --plain --help --version welcome check run test inspect explain doctor init wire model spec catalog examples new completions trace dap lsp mcp help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 1 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__catalog)
            opts="-h --json --tools --color --hyperlink --ascii --plain --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__check)
            opts="-h --json --infer-permits --fix --native-strict --model --color --hyperlink --ascii --plain --help [FILES]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --model)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__completions)
            opts="-h --color --hyperlink --ascii --plain --help bash elvish fish powershell zsh"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__dap)
            opts="-h --color --hyperlink --ascii --plain --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__doctor)
            opts="-h --ping --json --color --hyperlink --ascii --plain --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__examples)
            opts="-h --color --hyperlink --ascii --plain --help list show copy run help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__examples__subcmd__copy)
            opts="-h --force --color --hyperlink --ascii --plain --help <SLUG> [DEST]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__examples__subcmd__help)
            opts="list show copy run help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__examples__subcmd__help__subcmd__copy)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__examples__subcmd__help__subcmd__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__examples__subcmd__help__subcmd__list)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__examples__subcmd__help__subcmd__run)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__examples__subcmd__help__subcmd__show)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__examples__subcmd__list)
            opts="-h --color --hyperlink --ascii --plain --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__examples__subcmd__run)
            opts="-h --model --var --quiet --no-progress --max-cost-usd --color --hyperlink --ascii --plain --help <SLUG>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --model)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --var)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --max-cost-usd)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__examples__subcmd__show)
            opts="-h --color --hyperlink --ascii --plain --help <SLUG>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__explain)
            opts="-h --json --forecast --color --hyperlink --ascii --plain --help <CODE>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help)
            opts="welcome check run test inspect explain doctor init wire model spec catalog examples new completions trace dap lsp mcp help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__catalog)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__check)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__completions)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__dap)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__doctor)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__examples)
            opts="list show copy run"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__examples__subcmd__copy)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__examples__subcmd__list)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__examples__subcmd__run)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__examples__subcmd__show)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__explain)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__init)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__inspect)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__lsp)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__mcp)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__model)
            opts="serve pull list rm"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__model__subcmd__list)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__model__subcmd__pull)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__model__subcmd__rm)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__model__subcmd__serve)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__new)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__run)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__spec)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__test)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__trace)
            opts="replay show ls rm outputs export verify reproduce peek flow"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__trace__subcmd__export)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__trace__subcmd__flow)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__trace__subcmd__ls)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__trace__subcmd__outputs)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__trace__subcmd__peek)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__trace__subcmd__replay)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__trace__subcmd__reproduce)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__trace__subcmd__rm)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__trace__subcmd__show)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__trace__subcmd__verify)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__welcome)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__help__subcmd__wire)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__init)
            opts="-y -h --force --yes --recipe --example --theme --wire --color --hyperlink --ascii --plain --help [DIR]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --recipe)
                    COMPREPLY=($(compgen -W "agentic starter ship content minimal" -- "${cur}"))
                    return 0
                    ;;
                --example)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --theme)
                    COMPREPLY=($(compgen -W "nika editor phosphor auto" -- "${cur}"))
                    return 0
                    ;;
                --wire)
                    COMPREPLY=($(compgen -W "cursor vscode windsurf claude claude-desktop cline codex continue zed opencode hermes gemini qwen lmstudio junie all" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__inspect)
            opts="-h --format --color --hyperlink --ascii --plain --help <FILE>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --format)
                    COMPREPLY=($(compgen -W "json mermaid dot ascii" -- "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__lsp)
            opts="-h --color --hyperlink --ascii --plain --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__mcp)
            opts="-h --transport --port --bind --color --hyperlink --ascii --plain --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --transport)
                    COMPREPLY=($(compgen -W "stdio http" -- "${cur}"))
                    return 0
                    ;;
                --port)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --bind)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__model)
            opts="-h --color --hyperlink --ascii --plain --help serve pull list rm help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__model__subcmd__help)
            opts="serve pull list rm help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__model__subcmd__help__subcmd__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__model__subcmd__help__subcmd__list)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__model__subcmd__help__subcmd__pull)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__model__subcmd__help__subcmd__rm)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__model__subcmd__help__subcmd__serve)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__model__subcmd__list)
            opts="-h --color --hyperlink --ascii --plain --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__model__subcmd__pull)
            opts="-y -h --yes --color --hyperlink --ascii --plain --help <OWNER/REPO[:QUANT]>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__model__subcmd__rm)
            opts="-h --color --hyperlink --ascii --plain --help <ID>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__model__subcmd__serve)
            opts="-h --model --tokenizer --port --model-id --color --hyperlink --ascii --plain --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --model)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --tokenizer)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --port)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --model-id)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__new)
            opts="-h --from --force --color --hyperlink --ascii --plain --help [DEST]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --from)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__run)
            opts="-h --json --output --no-progress --quiet --dry-run --model --var --resume --from --answer --task --no-trace-file --no-outputs --max-cost-usd --no-gc --color --hyperlink --ascii --plain --help [FILE]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --output)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --model)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --var)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --resume)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --from)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --answer)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --task)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --max-cost-usd)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__spec)
            opts="-h --canon --schema --color --hyperlink --ascii --plain --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__test)
            opts="-h --update --color --hyperlink --ascii --plain --help [FILE]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__trace)
            opts="-h --color --hyperlink --ascii --plain --help replay show ls rm outputs export verify reproduce peek flow help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__trace__subcmd__export)
            opts="-o -h --out --include-content --color --hyperlink --ascii --plain --help <TRACE>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --out)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -o)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__trace__subcmd__flow)
            opts="-h --color --hyperlink --ascii --plain --help [TRACE] [WORKFLOW]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__trace__subcmd__help)
            opts="replay show ls rm outputs export verify reproduce peek flow help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__trace__subcmd__help__subcmd__export)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__trace__subcmd__help__subcmd__flow)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__trace__subcmd__help__subcmd__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__trace__subcmd__help__subcmd__ls)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__trace__subcmd__help__subcmd__outputs)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__trace__subcmd__help__subcmd__peek)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__trace__subcmd__help__subcmd__replay)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__trace__subcmd__help__subcmd__reproduce)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__trace__subcmd__help__subcmd__rm)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__trace__subcmd__help__subcmd__show)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__trace__subcmd__help__subcmd__verify)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__trace__subcmd__ls)
            opts="-h --color --hyperlink --ascii --plain --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__trace__subcmd__outputs)
            opts="-h --color --hyperlink --ascii --plain --help [TRACE]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__trace__subcmd__peek)
            opts="-h --raw --color --hyperlink --ascii --plain --help <TRACE> <TASK>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__trace__subcmd__replay)
            opts="-h --demo --demo-fail --speed --no-outputs --color --hyperlink --ascii --plain --help [TRACE]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --speed)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__trace__subcmd__reproduce)
            opts="-h --color --hyperlink --ascii --plain --help <RECORDED> <FRESH>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__trace__subcmd__rm)
            opts="-h --older-than --all --force --color --hyperlink --ascii --plain --help [TRACE]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --older-than)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__trace__subcmd__show)
            opts="-h --demo --demo-fail --speed --no-outputs --color --hyperlink --ascii --plain --help [TRACE]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --speed)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__trace__subcmd__verify)
            opts="-h --color --hyperlink --ascii --plain --help [TRACES]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__welcome)
            opts="-h --json --deep --color --hyperlink --ascii --plain --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nika__subcmd__wire)
            opts="-h --dir --color --hyperlink --ascii --plain --help cursor vscode windsurf claude claude-desktop cline codex continue zed opencode hermes gemini qwen lmstudio junie all"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always never auto" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
    esac
}

if [[ "${BASH_VERSINFO[0]}" -eq 4 && "${BASH_VERSINFO[1]}" -ge 4 || "${BASH_VERSINFO[0]}" -gt 4 ]]; then
    complete -F _nika -o nosort -o bashdefault -o default nika
else
    complete -F _nika -o bashdefault -o default nika
fi
