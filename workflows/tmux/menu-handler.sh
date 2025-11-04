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

    # Discover workflows from prompts directory
    while IFS= read -r prompt_file; do
        local workflow_name=$(basename "$prompt_file" .md)

        # Skip system prompts (starting with _)
        [[ "$workflow_name" =~ ^_ ]] && continue

        local display_name="[W] $(workflow_display_name "$workflow_name")"
        local key=$(get_menu_key "$workflow_name" "$used_keys")
        used_keys="${used_keys}${key}"

        menu_items+=("$display_name")
        menu_items+=("$key")
        menu_items+=("run-shell 'bash $WORKFLOWS_DIR/tmux/menu-handler.sh workflow:$workflow_name'")
    done < <(find "$WORKFLOWS_DIR/prompts" -maxdepth 1 -name "*.md" -type f | sort)

    # Add separator between workflows and tasks
    if [ ${#menu_items[@]} -gt 0 ]; then
        menu_items+=("")
        menu_items+=("")
        menu_items+=("")
    fi

    # Discover tasks from tasks directory (macOS compatible)
    while IFS= read -r task_file; do
        local task_name=$(basename "$task_file")

        # Skip start-workflow (it's used internally, not directly)
        [[ "$task_name" == "start-workflow" ]] && continue

        # Check if file is executable
        [[ -x "$task_file" ]] || continue

        local display_name="[T] $(workflow_display_name "$task_name")"
        local key=$(get_menu_key "$task_name" "$used_keys")
        used_keys="${used_keys}${key}"

        menu_items+=("$display_name")
        menu_items+=("$key")
        menu_items+=("run-shell 'bash $WORKFLOWS_DIR/tmux/menu-handler.sh task:$task_name'")
    done < <(find "$WORKFLOWS_DIR/tasks" -maxdepth 1 -type f | sort)

    # Add separator and cancel option
    menu_items+=("")
    menu_items+=("")
    menu_items+=("")
    menu_items+=("Cancel")
    menu_items+=("q")
    menu_items+=("")

    # Display the menu
    tmux display-menu -T "Workflows & Tasks" "${menu_items[@]}"
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
    *)
        echo "Usage: $0 [menu|workflow:<name>|task:<name>]"
        exit 1
        ;;
esac