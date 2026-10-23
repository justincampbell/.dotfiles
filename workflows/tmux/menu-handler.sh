#!/usr/bin/env bash

# Workflow Menu Handler
# Displays tmux menu for AI-optimized development workflows

WORKFLOWS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Convert workflow filename to display name
# e.g., "review-github-pr" -> "Review GitHub PR"
workflow_display_name() {
    local name="$1"
    # Replace hyphens with spaces and capitalize each word
    echo "$name" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1'
}

# Build a sortable launch entry for the grouped session/project list.
# Emits a tab-delimited record: "<group>\t<lowercase-name>\t<display-name>\t<launch-name>"
# where group is 0=orchestrator, 1=ongoing, 2=untyped (anything else / absent).
build_launch_entry() {
    local yaml_file="$1"
    local launch_name="$2"

    local yaml_name; yaml_name=$(yq eval '.name' "$yaml_file" 2>/dev/null)
    local display_name
    if [ -n "$yaml_name" ] && [ "$yaml_name" != "null" ]; then
        display_name="$yaml_name"
    else
        display_name=$(workflow_display_name "$launch_name")
    fi

    local type; type=$(yq eval '.type' "$yaml_file" 2>/dev/null)
    local group
    case "$type" in
        orchestrator) group=0 ;;
        ongoing) group=1 ;;
        *) group=2 ;;
    esac

    local lc_name; lc_name=$(echo "$display_name" | tr '[:upper:]' '[:lower:]')
    printf '%s\t%s\t%s\t%s\n' "$group" "$lc_name" "$display_name" "$launch_name"
}

# Resolve the "project root" for a directory, used by the Edit project menu.
# Order: nearest ancestor (including itself) containing a .workflow.yml; else
# the git repo root (a linked worktree resolves to its main checkout); else the directory
# itself when it sits directly under ~/Code/<org>/. Prints the root, else nothing.
resolve_project_root() {
    local dir="$1"

    # 1. Nearest ancestor (including itself) containing a .workflow.yml
    local d="$dir"
    while [ -n "$d" ] && [ "$d" != "/" ]; do
        if [ -f "$d/.workflow.yml" ]; then
            echo "$d"
            return 0
        fi
        d=$(dirname "$d")
    done

    # 2. Git repo root; a linked worktree resolves to its main checkout, since
    #    worktrees are skipped by the project lists
    local common; common=$(git -C "$dir" rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
    if [ -n "$common" ]; then
        dirname "$common"
        return 0
    fi

    # 3. Directory sitting directly under ~/Code/<org>/
    if [ "$(dirname "$(dirname "$dir")")" = "$HOME/Code" ]; then
        echo "$dir"
        return 0
    fi

    return 1
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
    # Status file drives a small loading popup that re-renders as steps run.
    local status_file
    status_file=$(mktemp -t workflow-menu-status.XXXXXX)
    echo "Detecting current repo..." > "$status_file"

    # Mirror the user's menu theme on the popup, if set.
    local border_lines border_style style
    border_lines=$(tmux show-options -gqv menu-border-lines)
    border_style=$(tmux show-options -gqv menu-border-style)
    style=$(tmux show-options -gqv menu-style)
    local popup_flags=(-E -w 36 -h 3)
    [ -n "$border_lines" ] && popup_flags+=(-b "$border_lines")
    [ -n "$border_style" ] && popup_flags+=(-S "$border_style")
    [ -n "$style" ] && popup_flags+=(-s "$style")

    tmux display-popup "${popup_flags[@]}" \
        "printf '\e[?25l'
         while :; do
             msg=\$(cat '$status_file' 2>/dev/null)
             [ \"\$msg\" = '__DONE__' ] && break
             printf '\r\e[K  %s' \"\$msg\"
             sleep 0.1
         done
         printf '\e[?25h'" &
    local popup_pid=$!

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

    # Idea option: free-text prompt -> worktree + AI session
    local ikey=$(get_menu_key "idea" "$used_keys")
    used_keys="${used_keys}${ikey}"
    menu_items+=("Idea...")
    menu_items+=("$ikey")
    menu_items+=("run-shell 'bash $WORKFLOWS_DIR/tmux/menu-handler.sh idea'")

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

    # Open repo option
    local rkey=$(get_menu_key "repo" "$used_keys")
    used_keys="${used_keys}${rkey}"
    menu_items+=("Open project...")
    menu_items+=("$rkey")
    menu_items+=("run-shell 'bash $WORKFLOWS_DIR/tmux/menu-handler.sh open-repo'")

    # Clone repo option
    local ckey=$(get_menu_key "clone" "$used_keys")
    used_keys="${used_keys}${ckey}"
    menu_items+=("Clone project...")
    menu_items+=("$ckey")
    menu_items+=("run-shell 'bash $WORKFLOWS_DIR/tmux/menu-handler.sh clone-repo'")

    # Handle URL option
    local ukey=$(get_menu_key "url" "$used_keys")
    used_keys="${used_keys}${ukey}"
    menu_items+=("Handle URL...")
    menu_items+=("$ukey")
    menu_items+=("run-shell 'bash $WORKFLOWS_DIR/tmux/menu-handler.sh handle-url'")

    # Planning option: fuzzy-pick a recent planning session or a Shortcut epic/objective
    local pkey=$(get_menu_key "planning" "$used_keys")
    used_keys="${used_keys}${pkey}"
    menu_items+=("Planning...")
    menu_items+=("$pkey")
    menu_items+=("run-shell 'bash $WORKFLOWS_DIR/tmux/menu-handler.sh planning'")

    # Edit project option: track / set type / untrack the current project
    local edkey=$(get_menu_key "edit" "$used_keys")
    used_keys="${used_keys}${edkey}"
    menu_items+=("Edit project...")
    menu_items+=("$edkey")
    menu_items+=("run-shell 'bash $WORKFLOWS_DIR/tmux/menu-handler.sh edit-project'")

    # Separator before projects
    menu_items+=("")
    menu_items+=("")
    menu_items+=("")

    # Discover launchable sessions and projects, then render them grouped by
    # type. Sessions come from the sessions directory; projects are any dir
    # under ~/Code with a .workflow.yml, excluding git worktrees (whose marker
    # is a .git FILE). Entries render orchestrator -> ongoing -> untyped, each
    # group alphabetical (case-insensitive), with a separator between groups.
    echo "Scanning sessions..." > "$status_file"
    local launch_entries=()

    local sessions_dir="$WORKFLOWS_DIR/tmux/sessions"
    if [ -d "$sessions_dir" ]; then
        while IFS= read -r session_file; do
            local session_name=$(basename "$session_file" .yml)
            launch_entries+=("$(build_launch_entry "$session_file" "$session_name")")
        done < <(find "$sessions_dir" -maxdepth 1 -name "*.yml" -type f 2>/dev/null)
    fi

    echo "Discovering workflows..." > "$status_file"
    while IFS= read -r workflow_file; do
        local project_dir=$(dirname "$workflow_file")
        # Skip git worktrees (their .git is a FILE, not a directory)
        [ -f "$project_dir/.git" ] && continue
        local project_name=$(basename "$project_dir")
        launch_entries+=("$(build_launch_entry "$workflow_file" "$project_name")")
    done < <(find ~/Code -name ".workflow.yml" -maxdepth 3 2>/dev/null)

    # tmux silently refuses to draw a menu taller than the client, so budget
    # the launchable rows to the space left after the fixed rows: the action
    # items above (computed), the danger zone + Cancel below (3), the menu
    # border (2), and the status line (1).
    local client_height
    client_height=$(tmux display-message -p '#{client_height}' 2>/dev/null)
    case "$client_height" in
        ''|*[!0-9]*) client_height=40 ;;
    esac
    local fixed_rows=$(( ${#menu_items[@]} / 3 ))
    local budget=$(( client_height - fixed_rows - 6 ))
    [ "$budget" -lt 1 ] && budget=1

    local sorted_entries=()
    while IFS= read -r entry; do
        sorted_entries+=("$entry")
    done < <(printf '%s\n' "${launch_entries[@]}" | sort -t$'\t' -k1,1 -k2,2)

    # If the list can't fit even with both group separators, reserve the last
    # row for "More projects..." (the scrolling fzf picker).
    local more_needed=0 max_rows=$budget
    if [ $(( ${#sorted_entries[@]} + 2 )) -gt "$budget" ]; then
        more_needed=1
        max_rows=$(( budget - 1 ))
    fi

    # Render entries grouped by type, with a separator between non-empty groups.
    local prev_group="" rows=0
    local entry group lc_name display_name launch_name
    for entry in "${sorted_entries[@]}"; do
        IFS=$'\t' read -r group lc_name display_name launch_name <<< "$entry"
        [ -z "$group" ] && continue

        local sep=0
        [ -n "$prev_group" ] && [ "$group" != "$prev_group" ] && sep=1
        if [ $(( rows + sep + 1 )) -gt "$max_rows" ]; then
            break
        fi
        if [ "$sep" -eq 1 ]; then
            menu_items+=("")
            menu_items+=("")
            menu_items+=("")
            rows=$(( rows + 1 ))
        fi
        prev_group="$group"

        local key=$(get_menu_key "$launch_name" "$used_keys")
        used_keys="${used_keys}${key}"

        menu_items+=("$display_name")
        menu_items+=("$key")
        menu_items+=("run-shell 'bash $WORKFLOWS_DIR/tmux/menu-handler.sh session:$launch_name'")
        rows=$(( rows + 1 ))
    done

    if [ "$more_needed" -eq 1 ]; then
        local mkey=$(get_menu_key "more" "$used_keys")
        used_keys="${used_keys}${mkey}"
        menu_items+=("More projects...")
        menu_items+=("$mkey")
        menu_items+=("run-shell 'bash $WORKFLOWS_DIR/tmux/menu-handler.sh open-repo'")
    fi

    # Danger zone: clean up the current worktree (or kill the session if it's not
    # a worktree), plus a bulk picker for several at once. Guarded by capital
    # keys (never auto-assigned, need Shift) since they remove worktrees and kill
    # tmux: X gets a centered y/N modal that defaults to Cancel, B confirms
    # inside its own picker.
    menu_items+=("")
    menu_items+=("")
    menu_items+=("")
    menu_items+=("Clean up worktree / kill session")
    menu_items+=("X")
    menu_items+=("display-menu -T \" Clean up worktree / kill session? \" -x C -y C \"Cancel\" n \"\" \"Yes, clean up\" y \"run-shell 'bash $WORKFLOWS_DIR/tmux/menu-handler.sh cleanup'\"")
    menu_items+=("Clean up sessions in bulk...")
    menu_items+=("B")
    menu_items+=("run-shell 'bash $WORKFLOWS_DIR/tmux/menu-handler.sh cleanup-bulk'")

    # Cancel option
    menu_items+=("Cancel")
    menu_items+=("q")
    menu_items+=("")

    # Signal the loading popup to close, then show the real menu
    echo "__DONE__" > "$status_file"
    wait "$popup_pid" 2>/dev/null || true
    rm -f "$status_file"

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
            "run-shell 'echo \"%1\" > /tmp/start-worktree-desc && bash $WORKFLOWS_DIR/tmux/menu-handler.sh run-start-worktree'"
        ;;
    idea)
        pane_path=$(tmux display-message -p "#{pane_current_path}")
        safe_path="${pane_path//\'/\'\\\'\'}"
        tmux display-popup -E -w 80% -h 80% \
            "bash $WORKFLOWS_DIR/tmux/menu-handler.sh prompt-idea '$safe_path'"
        ;;
    open-worktree)
        pane_path=$(tmux display-message -p "#{pane_current_path}")
        safe_path="${pane_path//\'/\'\\\'\'}"
        tmux display-popup -E -w 80% -h 80% \
            "cd '$safe_path' && bash $WORKFLOWS_DIR/tasks/open-worktree"
        ;;
    open-repo)
        tmux display-popup -E -w 80% -h 80% \
            "bash $WORKFLOWS_DIR/tasks/open-repo"
        ;;
    planning)
        tmux display-popup -E -w 80% -h 80% \
            "bash $WORKFLOWS_DIR/tasks/planning-picker"
        ;;
    clone-repo)
        tmux command-prompt -p "GitHub URL or org/repo:" \
            "display-popup -E -w 80% -h 80% 'bash $WORKFLOWS_DIR/tasks/clone-github-repo \"%1\"'"
        ;;
    handle-url)
        tmux command-prompt -p "URL:" \
            "run-shell 'bash $WORKFLOWS_DIR/tasks/handle-workflow-url \"%1\"'"
        ;;
    edit-project)
        # Resolve the current project and show a submenu to track it, set its
        # type, or untrack it. Action items call back into this script and
        # re-resolve the project from the current pane (like the cleanup flow),
        # so no paths need to be embedded in tmux command strings.
        pane_path=$(tmux display-message -p "#{pane_current_path}")
        root=$(resolve_project_root "$pane_path")
        if [ -z "$root" ]; then
            tmux display-message "Not in a project"
            exit 0
        fi
        workflow_yml="$root/.workflow.yml"
        project_basename=$(basename "$root")

        # Title uses the .workflow.yml name if present, else the humanized dir.
        if [ -f "$workflow_yml" ]; then
            yaml_name=$(yq eval '.name' "$workflow_yml" 2>/dev/null)
            if [ -n "$yaml_name" ] && [ "$yaml_name" != "null" ]; then
                display_name="$yaml_name"
            else
                display_name=$(workflow_display_name "$project_basename")
            fi
        else
            display_name=$(workflow_display_name "$project_basename")
        fi

        submenu=()
        if [ ! -f "$workflow_yml" ]; then
            # Untracked: offer to create a .workflow.yml
            submenu+=("Track project")
            submenu+=("t")
            submenu+=("run-shell 'bash $WORKFLOWS_DIR/tmux/menu-handler.sh track-project'")
        else
            # Tracked: set/clear the type, or untrack. Mark the active type.
            current_type=$(yq eval '.type' "$workflow_yml" 2>/dev/null)
            orch_label="Type: orchestrator"
            ong_label="Type: ongoing"
            none_label="Type: none"
            case "$current_type" in
                orchestrator) orch_label="✓ $orch_label" ;;
                ongoing) ong_label="✓ $ong_label" ;;
                *) none_label="✓ $none_label" ;;
            esac

            submenu+=("$orch_label")
            submenu+=("o")
            submenu+=("run-shell 'bash $WORKFLOWS_DIR/tmux/menu-handler.sh set-project-type orchestrator'")

            submenu+=("$ong_label")
            submenu+=("g")
            submenu+=("run-shell 'bash $WORKFLOWS_DIR/tmux/menu-handler.sh set-project-type ongoing'")

            submenu+=("$none_label")
            submenu+=("n")
            submenu+=("run-shell 'bash $WORKFLOWS_DIR/tmux/menu-handler.sh unset-project-type'")

            # Separator before the danger zone
            submenu+=("")
            submenu+=("")
            submenu+=("")

            # Untrack: deletes the .workflow.yml only. Guarded by a capital X key
            # plus a centered y/N modal that defaults to Cancel (mirrors cleanup).
            submenu+=("Untrack project (delete .workflow.yml)")
            submenu+=("X")
            submenu+=("display-menu -T \" Untrack $display_name? \" -x C -y C \"Cancel\" n \"\" \"Yes, untrack\" y \"run-shell 'bash $WORKFLOWS_DIR/tmux/menu-handler.sh untrack-project'\"")
        fi

        submenu+=("Cancel")
        submenu+=("q")
        submenu+=("")

        tmux display-menu -T " Project: $display_name " "${submenu[@]}"
        ;;
    track-project)
        # Create a .workflow.yml with a humanized name for the current project.
        pane_path=$(tmux display-message -p "#{pane_current_path}")
        root=$(resolve_project_root "$pane_path")
        if [ -z "$root" ]; then
            tmux display-message "Not in a project"
            exit 0
        fi
        workflow_yml="$root/.workflow.yml"
        if [ -f "$workflow_yml" ]; then
            tmux display-message "Already tracked"
            exit 0
        fi
        humanized=$(workflow_display_name "$(basename "$root")")
        printf 'name: "%s"\n' "$humanized" > "$workflow_yml"
        tmux display-message "Tracked project: $humanized"
        ;;
    set-project-type)
        # Set .type on the current project's .workflow.yml (orchestrator|ongoing).
        project_type="$2"
        pane_path=$(tmux display-message -p "#{pane_current_path}")
        root=$(resolve_project_root "$pane_path")
        if [ -z "$root" ]; then
            tmux display-message "Not in a project"
            exit 0
        fi
        workflow_yml="$root/.workflow.yml"
        if [ ! -f "$workflow_yml" ]; then
            tmux display-message "Not a tracked project"
            exit 0
        fi
        yq eval -i ".type = \"$project_type\"" "$workflow_yml"
        tmux display-message "Set type: $project_type"
        ;;
    unset-project-type)
        # Remove .type from the current project's .workflow.yml.
        pane_path=$(tmux display-message -p "#{pane_current_path}")
        root=$(resolve_project_root "$pane_path")
        if [ -z "$root" ]; then
            tmux display-message "Not in a project"
            exit 0
        fi
        workflow_yml="$root/.workflow.yml"
        if [ ! -f "$workflow_yml" ]; then
            tmux display-message "Not a tracked project"
            exit 0
        fi
        yq eval -i 'del(.type)' "$workflow_yml"
        tmux display-message "Type cleared"
        ;;
    untrack-project)
        # Delete the current project's .workflow.yml (untrack it).
        pane_path=$(tmux display-message -p "#{pane_current_path}")
        root=$(resolve_project_root "$pane_path")
        if [ -z "$root" ]; then
            tmux display-message "Not in a project"
            exit 0
        fi
        workflow_yml="$root/.workflow.yml"
        if [ -f "$workflow_yml" ]; then
            rm -f "$workflow_yml"
            tmux display-message "Untracked project (deleted .workflow.yml)"
        else
            tmux display-message "Not a tracked project"
        fi
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
    cleanup)
        # Clean up the current worktree (removes worktree + kills its session).
        # Falls back to killing the current session if it isn't a worktree.
        # Runs in a new window so cleanup-git-worktree has a real pane/$TMUX_PANE.
        pane_path=$(tmux display-message -p "#{pane_current_path}")
        session_name=$(tmux display-message -p "#{session_name}")
        safe_path="${pane_path//\'/\'\\\'\'}"
        safe_session="${session_name//\'/\'\\\'\'}"
        tmux new-window -n cleanup \
            "bash $WORKFLOWS_DIR/tasks/cleanup-git-worktree '$safe_path' || tmux kill-session -t '=$safe_session'"
        ;;
    cleanup-bulk)
        # Multi-select several worktrees/sessions and clean them up in one pass.
        # The picker parks the client in a holding session first, so the active
        # session doesn't jump around as each one is killed.
        session_name=$(tmux display-message -p "#{session_name}")
        safe_session="${session_name//\'/\'\\\'\'}"
        tmux display-popup -E -w 80% -h 80% \
            "bash $WORKFLOWS_DIR/tasks/cleanup-sessions '$safe_session'"
        ;;
    prompt-idea)
        # Runs inside a display-popup: capture the idea in an editor modal,
        # flatten it to a single line, then hand off to start-idea in the repo.
        repo_path="$2"
        editor="${EDITOR:-nvim}"
        idea_file=$(mktemp)
        "$editor" "$idea_file"
        idea=$(tr '\n\t' '  ' < "$idea_file" | sed -e 's/  */ /g' -e 's/^ *//' -e 's/ *$//')
        rm -f "$idea_file"
        if [ -z "$idea" ]; then
            echo "No idea entered — aborting."
            sleep 1
            exit 0
        fi
        cd "$repo_path"
        exec bash "$WORKFLOWS_DIR/tasks/start-idea" "$idea"
        ;;
    *)
        echo "Usage: $0 [menu|workflow:<name>|task:<name>]"
        exit 1
        ;;
esac
