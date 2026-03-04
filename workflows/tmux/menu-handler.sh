#!/usr/bin/env bash

# Workflow Menu Handler
# Displays tmux menu for AI-optimized development workflows

WORKFLOWS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# AI CLI - can be overridden with environment variable
AI_CLI="${WORKFLOW_AI_CLI:-copilot}"

# Convert workflow filename to display name
# e.g., "review-github-pr" -> "Review GitHub PR"
workflow_display_name() {
    local name="$1"
    # Replace hyphens with spaces and capitalize each word
    echo "$name" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1'
}

# Get a unique key for a menu item (single character)
# Uses first letter, or finds next available letter if taken
get_menu_key() {
    local name="$1"
    local used_keys="$2"

    # Try first letter (lowercase)
    local first_char=$(echo "$name" | head -c1 | tr '[:upper:]' '[:lower:]')
    if [[ ! "$used_keys" =~ $first_char ]]; then
        echo "$first_char"
        return
    fi

    # Try each letter in the name
    for ((i=0; i<${#name}; i++)); do
        local char="${name:$i:1}"
        char=$(echo "$char" | tr '[:upper:]' '[:lower:]')
        if [[ "$char" =~ [a-z] ]] && [[ ! "$used_keys" =~ $char ]]; then
            echo "$char"
            return
        fi
    done

    # Fallback: find any unused letter
    for char in {a..z}; do
        if [[ ! "$used_keys" =~ $char ]]; then
            echo "$char"
            return
        fi
    done

    # Last resort: use a number
    echo "0"
}

show_workflow_menu() {
    local menu_items=()
    local used_keys=""

    # New worktree option at top, detect current repo
    local pane_path=$(tmux display-message -p "#{pane_current_path}" 2>/dev/null)
    # Use --git-common-dir to get the main repo name (not the worktree)
    local git_common_dir=$(git -C "$pane_path" rev-parse --git-common-dir 2>/dev/null)
    local repo_name=$(cd "$pane_path" && basename "$(cd "$git_common_dir/.." && pwd)" 2>/dev/null)
    local worktree_label="New Worktree..."
    if [ -n "$repo_name" ]; then
        worktree_label="New $repo_name worktree..."
    fi
    local key=$(get_menu_key "start-worktree" "$used_keys")
    used_keys="${used_keys}${key}"
    menu_items+=("$worktree_label")
    menu_items+=("$key")
    menu_items+=("run-shell 'bash $WORKFLOWS_DIR/tmux/menu-handler.sh start-worktree'")

    # Existing worktree option
    local existing_label="Existing Worktree..."
    if [ -n "$repo_name" ]; then
        existing_label="Existing $repo_name worktree..."
    fi
    local ekey=$(get_menu_key "existing-worktree" "$used_keys")
    used_keys="${used_keys}${ekey}"
    menu_items+=("$existing_label")
    menu_items+=("$ekey")
    menu_items+=("run-shell 'bash $WORKFLOWS_DIR/tmux/menu-handler.sh open-worktree'")

    # Separator before projects
    menu_items+=("")
    menu_items+=("")
    menu_items+=("")

    # Discover sessions from sessions directory
    local sessions_dir="$WORKFLOWS_DIR/tmux/sessions"
    if [ -d "$sessions_dir" ]; then
        while IFS= read -r session_file; do
            local session_name=$(basename "$session_file" .yml)

            local display_name=$(workflow_display_name "$session_name")
            local key=$(get_menu_key "$session_name" "$used_keys")
            used_keys="${used_keys}${key}"

            menu_items+=("$display_name")
            menu_items+=("$key")
            menu_items+=("run-shell 'bash $WORKFLOWS_DIR/tmux/menu-handler.sh session:$session_name'")
        done < <(find "$sessions_dir" -maxdepth 1 -name "*.yml" -type f 2>/dev/null | sort)
    fi

    # Discover .workflow.yml files from ~/Code projects
    while IFS= read -r workflow_file; do
        local project_dir=$(dirname "$workflow_file")
        local project_name=$(basename "$project_dir")

        local display_name=$(workflow_display_name "$project_name")
        local key=$(get_menu_key "$project_name" "$used_keys")
        used_keys="${used_keys}${key}"

        menu_items+=("$display_name")
        menu_items+=("$key")
        menu_items+=("run-shell 'bash $WORKFLOWS_DIR/tmux/menu-handler.sh session:$project_name'")
    done < <(find ~/Code -name ".workflow.yml" -maxdepth 3 2>/dev/null | sort)

    # Add separator and cancel option
    menu_items+=("")
    menu_items+=("")
    menu_items+=("")
    menu_items+=("Cancel")
    menu_items+=("q")
    menu_items+=("")

    # Display the menu
    tmux display-menu "${menu_items[@]}"
}

launch_session() {
    local session_name="$1"
    "$WORKFLOWS_DIR/tasks/load-tmux-session" "$session_name"
}

launch_workflow() {
    local workflow_name="$1"

    # Check if workflow needs arguments by looking for {{arg in the prompt file
    local prompt_file="$WORKFLOWS_DIR/prompts/${workflow_name}.md"

    if grep -q '{{arg' "$prompt_file" 2>/dev/null; then
        # Workflow uses template variables, prompt for arguments
        tmux command-prompt -p "Arguments for $workflow_name (e.g., PR URL):" \
            "run-shell 'bash $WORKFLOWS_DIR/tmux/menu-handler.sh run-workflow:$workflow_name:%1'"
    else
        # No template variables, run directly without prompting
        run_workflow_with_args "$workflow_name" ""
    fi
}

run_workflow_with_args() {
    local workflow_name="$1"
    shift
    local args="$@"

    # Use start-workflow task
    if [ -n "$args" ]; then
        "$WORKFLOWS_DIR/tasks/start-workflow" "$workflow_name" $args
    else
        "$WORKFLOWS_DIR/tasks/start-workflow" "$workflow_name"
    fi
}

launch_task() {
    local task_name="$1"

    # Get current pane's working directory
    local current_dir=$(tmux display-message -p "#{pane_current_path}")

    # Some tasks can use the current directory as default
    case "$task_name" in
        "cleanup-git-worktree")
            # Run cleanup on current directory without prompting
            run_task_with_args "$task_name" "$current_dir"
            ;;
        *)
            # For other tasks, prompt for arguments
            tmux command-prompt -p "Arguments for $task_name (optional):" \
                "run-shell 'bash $WORKFLOWS_DIR/tmux/menu-handler.sh run-task:$task_name:%1'"
            ;;
    esac
}

run_task_with_args() {
    local task_name="$1"
    shift
    local args="$@"

    # Run the task in a new window
    if [ -n "$args" ]; then
        tmux new-window -n "$task_name" "$WORKFLOWS_DIR/tasks/$task_name $args"
    else
        tmux new-window -n "$task_name" "$WORKFLOWS_DIR/tasks/$task_name"
    fi
}

# Main execution
case "${1:-menu}" in
    "menu")
        show_workflow_menu
        ;;
    session:*)
        session_name="${1#session:}"
        launch_session "$session_name"
        ;;
    workflow:*)
        workflow_name="${1#workflow:}"
        launch_workflow "$workflow_name"
        ;;
    run-workflow:*)
        # Format: run-workflow:workflow-name:arg1 arg2 arg3
        workflow_info="${1#run-workflow:}"
        workflow_name="${workflow_info%%:*}"
        args="${workflow_info#*:}"
        run_workflow_with_args "$workflow_name" $args
        ;;
    task:*)
        task_name="${1#task:}"
        launch_task "$task_name"
        ;;
    run-task:*)
        # Format: run-task:task-name:arg1 arg2 arg3
        task_info="${1#run-task:}"
        task_name="${task_info%%:*}"
        args="${task_info#*:}"
        run_task_with_args "$task_name" $args
        ;;
    start-worktree)
        tmux command-prompt -p "Branch description:" \
            "run-shell 'printf \"%%s\" \"%%\" > /tmp/start-worktree-desc && bash $WORKFLOWS_DIR/tmux/menu-handler.sh run-start-worktree'"
        ;;
    open-worktree)
        pane_path=$(tmux display-message -p "#{pane_current_path}")
        safe_path="${pane_path//\'/\'\\\'\'}"
        tmux display-popup -E -w 80% -h 80% \
            "cd '$safe_path' && bash $WORKFLOWS_DIR/tasks/open-worktree"
        ;;
    run-start-worktree)
        pane_path=$(tmux display-message -p "#{pane_current_path}")
        description=$(cat /tmp/start-worktree-desc)
        rm -f /tmp/start-worktree-desc
        # Escape single quotes in description and path for safe shell embedding
        safe_desc="${description//\'/\'\\\'\'}"
        safe_path="${pane_path//\'/\'\\\'\'}"
        tmux display-popup -E -w 80% -h 80% \
            "cd '$safe_path' && bash $WORKFLOWS_DIR/tasks/start-worktree '$safe_desc'"
        ;;
    *)
        echo "Usage: $0 [menu|workflow:<name>|task:<name>]"
        exit 1
        ;;
esac
