#!/bin/bash
# Shared utilities for workflow tasks

# Convert any string to a valid git branch name
# Lowercases, replaces non-alphanumeric chars with hyphens, truncates to 60 chars
slugify_branch_name() {
    local input="$*"
    echo "$input" \
        | tr '[:upper:]' '[:lower:]' \
        | sed 's/[^a-z0-9]/-/g' \
        | sed 's/-\{2,\}/-/g' \
        | sed 's/^-//;s/-$//' \
        | cut -c1-60 \
        | sed 's/-$//'
}

# List available tasks with descriptions from first comment line
list_available_tasks() {
    local tasks_dir="$(dirname "${BASH_SOURCE[0]}")/tasks"

    for task_file in "$tasks_dir"/*; do
        if [ -f "$task_file" ] && [ -x "$task_file" ]; then
            local task_name=$(basename "$task_file")
            local description=$(head -2 "$task_file" | tail -1 | sed 's/^# *//')
            echo "$task_name: $description"
        fi
    done
}

# Parse GitHub URL to extract org, repo, and optionally PR/issue number
parse_github_url() {
    local github_url="$1"
    local extract_number="${2:-false}"

    if [ "$extract_number" = "true" ]; then
        # Parse PR URL: https://github.com/org/repo/pull/123
        if [[ "$github_url" =~ github\.com[/:]([^/]+)/([^/\.]+)/pull/([0-9]+) ]]; then
            echo "${BASH_REMATCH[1]} ${BASH_REMATCH[2]} ${BASH_REMATCH[3]}"
            return 0
        fi

        # Parse Issue URL: https://github.com/org/repo/issues/123
        if [[ "$github_url" =~ github\.com[/:]([^/]+)/([^/\.]+)/issues/([0-9]+) ]]; then
            echo "${BASH_REMATCH[1]} ${BASH_REMATCH[2]} ${BASH_REMATCH[3]}"
            return 0
        fi

        echo "Error: Invalid GitHub PR/Issue URL format: $github_url" >&2
        return 1
    else
        # Parse repo URL: https://github.com/org/repo (with optional /pull/123, /issues/123, or .git)
        if [[ "$github_url" =~ github\.com[/:]([^/]+)/([^/\.]+) ]]; then
            echo "${BASH_REMATCH[1]} ${BASH_REMATCH[2]}"
        else
            echo "Error: Invalid GitHub URL format: $github_url" >&2
            return 1
        fi
    fi
}

# Get the standard Code directory path for a GitHub repo
get_github_repo_path() {
    local org="$1"
    local repo="$2"
    echo "$HOME/Code/$org/$repo"
}

# Extract YAML frontmatter from markdown files
parse_frontmatter() {
    local file="$1"
    local key="${2:-}"

    if [ ! -f "$file" ]; then
        echo "Error: File '$file' not found" >&2
        return 1
    fi

    # Extract everything between --- lines
    local frontmatter
    frontmatter=$(sed -n '/^---$/,/^---$/p' "$file" | sed '1d;$d')

    if [ -n "$key" ]; then
        # Extract specific key using yq
        echo "$frontmatter" | yq ".$key" 2>/dev/null | grep -v "^null$" || true
    else
        # Return all frontmatter
        echo "$frontmatter"
    fi
}

# Print the tmux session for the planning vault, creating "planning" if none exists.
# Matches on session path so it converges with sessions ensure-tmux-session names after the dir.
ensure_planning_session() {
    local planning_dir session_name
    planning_dir=$(cd "$1" && pwd)

    session_name=$(tmux list-sessions -F "#{session_path}	#{session_name}" 2>/dev/null \
        | awk -F'\t' -v dir="$planning_dir" '$1 == dir { print $2; exit }')

    if [ -z "$session_name" ]; then
        session_name="planning"
        echo "Creating planning session..." >&2
        tmux new-session -d -s "$session_name" -c "$planning_dir"
        tmux rename-window -t "$(tmux list-windows -t "=$session_name" -F '#{window_id}' | head -1)" "shell"
    fi

    echo "$session_name"
}

# Print the name of the tmux session whose start directory is this path, if any.
# Sessions get humanized names after launch, so a name derived from the directory
# no longer finds them; matching by path reuses the session instead of adding a twin.
session_for_path() {
    local dir
    dir=$(cd "$1" 2>/dev/null && pwd -P) || return 0
    tmux list-sessions -F "#{session_path}	#{session_name}" 2>/dev/null \
        | awk -F'\t' -v d="$dir" '$1 == d { print $2; exit }'
}

# Run a network call with a time limit and a dated message when it starts, so a
# stalled launch shows which step hung instead of sitting silent for an hour.
# Usage: with_timeout <seconds> <command...>
with_timeout() {
    local secs="$1"; shift
    echo "[$(date '+%H:%M:%S')] $*" >&2
    if command -v timeout > /dev/null 2>&1; then
        timeout "$secs" "$@"
    elif command -v gtimeout > /dev/null 2>&1; then
        gtimeout "$secs" "$@"
    else
        "$@"
    fi
    local rc=$?
    if [ "$rc" = 124 ]; then
        echo "Timed out after ${secs}s: $*" >&2
    fi
    return $rc
}

# Claude Code asks "Yes, I trust this folder" once per path, which blocks an
# unattended launch in a brand-new worktree. A worktree is the same code as its
# base checkout, so it inherits the base's answer; nothing else is ever trusted.
pretrust_worktree() {
    local dir="$1" cfg="$HOME/.claude.json" base tmp
    [ -f "$dir/.git" ] && [ -f "$cfg" ] && command -v jq > /dev/null 2>&1 || return 0
    base=$(git -C "$dir" rev-parse --git-common-dir 2>/dev/null) || return 0
    [ -n "$base" ] || return 0
    base=$(cd "$base/.." && pwd) || return 0
    [ "$(jq -r --arg p "$base" '.projects[$p].hasTrustDialogAccepted // false' "$cfg")" = "true" ] || return 0
    [ "$(jq -r --arg p "$dir" '.projects[$p].hasTrustDialogAccepted // false' "$cfg")" = "true" ] && return 0
    tmp=$(mktemp "$cfg.XXXXXX") || return 0
    if jq --arg p "$dir" '.projects[$p] = ((.projects[$p] // {}) + {hasTrustDialogAccepted: true})' "$cfg" > "$tmp"; then
        mv "$tmp" "$cfg"
        echo "Trusted $dir for Claude (inherited from $base)" >&2
    else
        rm -f "$tmp"
    fi
}

# Watch a pane for Claude's trust dialog; returns 1 (after a loud message) if it
# is still there once the wait is over.
# Usage: fail_on_trust_dialog <pane-or-window-target> [seconds]
fail_on_trust_dialog() {
    local target="$1" secs="${2:-30}" i seen=false
    for ((i=0; i<secs; i++)); do
        sleep 1
        if tmux capture-pane -p -t "$target" 2>/dev/null | grep -q 'trust this folder'; then
            seen=true
        elif [ "$seen" = true ]; then
            return 0
        fi
    done
    if [ "$seen" = true ]; then
        echo "ERROR: Claude is waiting on the workspace-trust dialog in $target after ${secs}s; nothing will run until it is answered." >&2
        return 1
    fi
    return 0
}
