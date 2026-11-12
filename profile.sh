alias gp='git push'

# We only install nvim and not vim so let's make vim shortcut to nvim
alias vim='nvim'

# Print resume commands for Claude and Codex histories containing a literal string.
which_agent() {
    if [ "$#" -ne 1 ]; then
        echo 'Usage: which_agent STRING' >&2
        return 2
    fi
    local directory matches file session_id
    local -a histories=()
    for directory in "$HOME/.claude/projects" "$HOME/.codex/sessions" "$HOME/.codex/archived_sessions"; do
        if [ -d "$directory" ]; then
            histories+=("$directory")
        fi
    done
    if [ "${#histories[@]}" -eq 0 ]; then
        return 1
    fi
    matches=$(grep -rlF --include='*.jsonl' -- "$1" "${histories[@]}") || return $?
    while IFS= read -r file; do
        case "$file" in
            "$HOME/.codex/"*)
                # Subagents have their own id; session_id identifies the main session.
                session_id=$(head -n 1 "$file" | jq -er '.payload | .session_id // .parent_thread_id // .id') || return $?
                printf 'codex resume %q\n' "$session_id"
                ;;
            *)
                session_id=${file##*/}
                printf 'claude --resume %q\n' "${session_id%.jsonl}"
                ;;
        esac
    done <<< "$matches" | sort -u
}

## Julia shortcuts

jp() {
	cd ~/.julia/dev
	if [ "$#" -ge 1 ]; then
		cd $1
	fi
}

jclone() {
	cd ~/.julia/dev
    git clone "git@github.com:$1/$2.jl.git" && mv $2.jl $2 && cd $2
}

alias jformat="julia -e 'using JuliaFormatter; format(\"src\"); format(\"test\")'"
alias jformatall="julia -e 'using JuliaFormatter; format(\".\", verbose=true)'"
alias pluto="julia -e 'import Pluto; Pluto.run()'"

export PATH=/home/blegat/.julia/bin${PATH:+:${PATH}}

# Julia REPL for Vim
jv() {
    julia "$@" -i -e 'using Revise; using REPLSmuggler; smuggle()'
}

jt() {
    if [ -f test/Project.toml ]; then
        jv --project=test
    else
        jv --project
    fi
}

jd() {
    jv --project=docs
}
