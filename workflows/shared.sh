#!/bin/bash
# Shared utilities for workflow tasks

# Get the configured AI CLI command with fallback
get_workflow_ai_cli() {
    echo "${WORKFLOW_AI_CLI:-claude}"
}

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

# Create or switch to a tmux session for a worktree
# Args: worktree_dir branch_name
ensure_worktree_session() {
    local worktree_dir="$1"
    local branch_name="$2"

    local repo_name
    repo_name=$(basename "$(cd "$(git rev-parse --git-common-dir)/.." && pwd)")
    local session_name="${repo_name}-${branch_name}"

    # Switch to existing session if it exists
    if tmux has-session -t "$session_name" 2>/dev/null; then
        echo "Session already exists, switching to $session_name..."
        tmux switch-client -t "$session_name"
        return 0
    fi

    echo "Session: $session_name"
    echo ""

    local AI_CLI
    AI_CLI=$(get_workflow_ai_cli "")
    tmux new-session -d -s "$session_name" -c "$worktree_dir" -n "ai"
    sleep 0.1
    tmux send-keys -t "$session_name:ai" "$AI_CLI" C-m

    echo "Done! Switching to session..."
    tmux switch-client -t "$session_name"
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
