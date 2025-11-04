#!/bin/bash
# Shared utilities for workflow tasks

# Get the configured AI CLI command with fallback
get_workflow_ai_cli() {
    echo "${WORKFLOW_AI_CLI:-claude}"
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

# Parse GitHub URL to extract org, repo, and optionally PR number
parse_github_url() {
    local github_url="$1"
    local extract_pr="${2:-false}"

    if [ "$extract_pr" = "true" ]; then
        # Parse PR URL: https://github.com/org/repo/pull/123
        if [[ "$github_url" =~ github\.com[/:]([^/]+)/([^/\.]+)/pull/([0-9]+) ]]; then
            echo "${BASH_REMATCH[1]} ${BASH_REMATCH[2]} ${BASH_REMATCH[3]}"
        else
            echo "Error: Invalid GitHub PR URL format: $github_url" >&2
            return 1
        fi
    else
        # Parse repo URL: https://github.com/org/repo (with optional /pull/123 or .git)
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
