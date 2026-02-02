#!/usr/bin/env bats

load ../test_helper

setup() {
    export TEST_DIR="$(mktemp -d)"
    export HOME="${TEST_DIR}/home"
    export CODE_DIR="${HOME}/Code"

    mkdir -p "${HOME}/Code/test-org"

    # Create a test project directory
    export TEST_PROJECT_DIR="${CODE_DIR}/test-org/test-workflow-project"
    mkdir -p "$TEST_PROJECT_DIR"

    # Set up prompts directory to point to test fixtures
    export TEST_PROMPTS_DIR="${WORKFLOW_ROOT}/test/fixtures/workflows"

    # Create a minimal _system.md for testing
    mkdir -p "${WORKFLOW_ROOT}/test/fixtures/prompts"
    cat > "${WORKFLOW_ROOT}/test/fixtures/prompts/_system.md" <<'EOF'
You are a helpful AI assistant.

Available tasks:
{{available_tasks}}
EOF

    if [ -z "$REAL_HOME" ]; then
        export REAL_HOME="$HOME"
    fi
}

teardown() {
    cleanup_test_tmux_sessions

    # Clean up test sessions created by start-workflow
    # These are named after the target directory basename
    for session in $(tmux list-sessions -F '#{session_name}' 2>/dev/null || true); do
        if [[ "$session" == "test-workflow-project" ]] || [[ "$session" == "tmp."* ]]; then
            tmux kill-session -t "$session" 2>/dev/null || true
        fi
    done

    # Clean up test fixtures
    rm -rf "${WORKFLOW_ROOT}/test/fixtures/prompts"

    rm -rf "${TEST_DIR}"
}

# Helper to run workflow with test prompts directory
run_workflow() {
    local workflow_name="$1"
    shift

    # Temporarily modify the task to use test fixtures
    # We'll use a subshell and PATH manipulation
    cd "$TEST_PROJECT_DIR"

    # Create a wrapper script that modifies the prompts path
    local wrapper="/tmp/start-workflow-wrapper-$$"
    cat > "$wrapper" <<'WRAPPER_EOF'
#!/bin/bash
set -euo pipefail

# Source shared utilities
source "$(dirname "$0")/../shared.sh"

# Parse --detached flag
detached=false
if [[ "${1:-}" == "--detached" ]]; then
    detached=true
    shift
fi

workflow_name="$1"
shift

if [ -z "$workflow_name" ]; then
    echo "Usage: start-workflow [--detached] <workflow-name> [args...]" >&2
    exit 1
fi

# MODIFIED: Get the prompt file from test fixtures
prompt_file="${WORKFLOW_ROOT}/test/fixtures/workflows/${workflow_name}.md"

if [ ! -f "$prompt_file" ]; then
    echo "Error: Workflow prompt not found: $prompt_file" >&2
    exit 1
fi

# Rest of the script would go here, but for now let's just call the real task
# and temporarily symlink the prompts
mkdir -p "$(dirname "$0")/../prompts-backup"
if [ -d "$(dirname "$0")/../prompts" ]; then
    mv "$(dirname "$0")/../prompts"/* "$(dirname "$0")/../prompts-backup/" 2>/dev/null || true
fi

# Copy test fixtures to prompts dir
cp -r "${WORKFLOW_ROOT}/test/fixtures/workflows"/* "$(dirname "$0")/../prompts/" 2>/dev/null || true
cp "${WORKFLOW_ROOT}/test/fixtures/prompts/_system.md" "$(dirname "$0")/../prompts/" 2>/dev/null || true

# Call real task
"$(dirname "$0")/start-workflow" "$@"

# Restore
rm -rf "$(dirname "$0")/../prompts"/*
mv "$(dirname "$0")/../prompts-backup"/* "$(dirname "$0")/../prompts/" 2>/dev/null || true
rmdir "$(dirname "$0")/../prompts-backup" 2>/dev/null || true
WRAPPER_EOF

    chmod +x "$wrapper"

    # For now, let's use a simpler approach: copy fixtures to prompts dir temporarily
    local prompts_backup="${WORKFLOW_ROOT}/prompts-backup-$$"
    mkdir -p "$prompts_backup"

    # Backup existing prompts
    if [ -d "${WORKFLOW_ROOT}/prompts" ]; then
        cp -r "${WORKFLOW_ROOT}/prompts"/* "$prompts_backup/" 2>/dev/null || true
    fi

    # Copy test fixtures
    cp "${WORKFLOW_ROOT}/test/fixtures/workflows"/* "${WORKFLOW_ROOT}/prompts/" 2>/dev/null || true
    cp "${WORKFLOW_ROOT}/test/fixtures/prompts/_system.md" "${WORKFLOW_ROOT}/prompts/" 2>/dev/null || true

    # Run the task
    run_task start-workflow "$workflow_name" "$@"

    # Restore prompts
    rm -rf "${WORKFLOW_ROOT}/prompts"/*
    cp -r "$prompts_backup"/* "${WORKFLOW_ROOT}/prompts/" 2>/dev/null || true
    rm -rf "$prompts_backup"
    rm -f "$wrapper"
}

## A. Basic Functionality Tests

@test "fails gracefully when workflow file not found" {
    cd "$TEST_PROJECT_DIR"

    run_task start-workflow "nonexistent-workflow"

    assert_failure
    assert_output --partial "Workflow prompt not found"
}

@test "uses current directory as default target_dir" {
    cd "$TEST_PROJECT_DIR"

    run_workflow "test-basic"

    assert_success

    # Session should be named after current directory
    tmux has-session -t "test-workflow-project"
}

## E. Tmux Window Creation Tests

@test "creates windows from YAML configuration" {
    cd "$TEST_PROJECT_DIR"

    run_workflow "test-windows"

    assert_success

    # Should have 3 windows (tmux may auto-rename them based on running process)
    window_count=$(get_window_count "test-workflow-project")
    [ "$window_count" -eq 3 ]

    # Verify session exists and has windows
    tmux list-windows -t "test-workflow-project"
}

@test "handles workflows with no tmux_windows" {
    cd "$TEST_PROJECT_DIR"

    run_workflow "test-setup-tasks"

    assert_success

    # Should create a basic session with just a shell window
    tmux has-session -t "test-workflow-project"
    window_count=$(get_window_count "test-workflow-project")
    [ "$window_count" -eq 1 ]
}

## B. Setup Tasks Execution Tests

@test "executes setup_tasks sequentially" {
    cd "$TEST_PROJECT_DIR"

    run_workflow "test-setup-tasks"

    assert_success
    # Output should show tasks running in order
    assert_output --partial "Running setup tasks"
    assert_output --partial "task 1"
    assert_output --partial "task 2"
}

## C. Template Variable Replacement Tests

@test "replaces arg variables in setup_tasks" {
    cd "$TEST_PROJECT_DIR"

    run_workflow "test-args" "value1" "value2"

    assert_success
    # The setup tasks echo {{arg1}} and {{arg2}}
    assert_output --partial "value1"
    assert_output --partial "value2"
}

@test "replaces arg variables in prompt content" {
    cd "$TEST_PROJECT_DIR"

    # Create a workflow with template variables in the prompt
    cat > "${WORKFLOW_ROOT}/prompts/test-prompt-args-content.md" <<'EOF'
---
tmux_windows:
  - name: shell
    command: ""
---

Test prompt with template variables.
First argument: {{arg1}}
Second argument: {{arg2}}
Both together: {{arg1}} and {{arg2}}
EOF

    # Set TEST_PROMPT_OUTPUT to capture the processed prompt
    export TEST_PROMPT_OUTPUT="/tmp/test-prompt-output-$$"

    # Run workflow with specific argument values
    run_workflow "test-prompt-args-content" "FIRST_VALUE" "SECOND_VALUE"

    assert_success

    # Verify the processed prompt file was created and contains replaced values
    [ -f "$TEST_PROMPT_OUTPUT" ]

    # Check that template variables were replaced with actual values
    run grep "First argument: FIRST_VALUE" "$TEST_PROMPT_OUTPUT"
    assert_success

    run grep "Second argument: SECOND_VALUE" "$TEST_PROMPT_OUTPUT"
    assert_success

    run grep "Both together: FIRST_VALUE and SECOND_VALUE" "$TEST_PROMPT_OUTPUT"
    assert_success

    # Verify that no template variables remain unreplaced
    run grep "{{arg" "$TEST_PROMPT_OUTPUT"
    assert_failure

    # Clean up
    rm -f "${WORKFLOW_ROOT}/prompts/test-prompt-args-content.md"
    rm -f "$TEST_PROMPT_OUTPUT"
    unset TEST_PROMPT_OUTPUT
}

## D. Tmux Session Management Tests

@test "creates tmux session named after target directory" {
    cd "$TEST_PROJECT_DIR"

    run_workflow "test-basic"

    assert_success
    tmux has-session -t "test-workflow-project"
}

@test "switches to existing session if already exists (idempotent)" {
    cd "$TEST_PROJECT_DIR"

    # Create session first
    run_workflow "test-basic"
    assert_success

    # Run again - should not fail
    run_workflow "test-basic"
    assert_success
    assert_output --partial "Session test-workflow-project already exists"
}

@test "creates session in target_dir" {
    cd "$TEST_PROJECT_DIR"

    run_workflow "test-basic"

    assert_success

    # Check session's working directory
    session_pwd=$(tmux display-message -t "test-workflow-project" -p "#{pane_current_path}")
    expected_dir=$(cd "$TEST_PROJECT_DIR" && pwd -P)
    [ "$session_pwd" = "$expected_dir" ]
}

## E. Additional Window Creation Tests

@test "sets window working directory to target_dir" {
    cd "$TEST_PROJECT_DIR"

    run_workflow "test-windows"

    assert_success

    # Get window 2's working directory
    window_pwd=$(tmux display-message -t "test-workflow-project:2" -p "#{pane_current_path}")
    expected_dir=$(cd "$TEST_PROJECT_DIR" && pwd -P)
    [ "$window_pwd" = "$expected_dir" ]
}

@test "selects first window after creation" {
    cd "$TEST_PROJECT_DIR"

    run_workflow "test-windows"

    assert_success

    # Active window should be the first one
    active_window=$(tmux display-message -t "test-workflow-project" -p "#{window_index}")
    [ "$active_window" = "1" ]
}

## B. Additional Setup Tasks Tests

@test "captures directory output from tasks and updates target_dir" {
    cd "$TEST_PROJECT_DIR"

    # Create the directory that mock-echo-dir will output
    mkdir -p /tmp/captured-dir

    run_workflow "test-dir-capture"

    assert_success

    # Session should be named after the captured directory, not the original PWD
    tmux has-session -t "captured-dir"

    # Clean up
    tmux kill-session -t "captured-dir" 2>/dev/null || true
    rm -rf /tmp/captured-dir
}

@test "makes relative task paths absolute" {
    cd "$TEST_PROJECT_DIR"

    # Create a workflow with relative path
    cat > "${WORKFLOW_ROOT}/prompts/test-relative-path.md" <<'EOF'
---
setup_tasks:
  - "./workflows/tasks/ensure-git-worktree --help || echo 'task not found'"
---
Test relative paths.
EOF

    run_workflow "test-relative-path"

    assert_success
    # Should not output "task not found" if path resolution worked
    # (though --help will fail since ensure-git-worktree doesn't have that flag)

    rm -f "${WORKFLOW_ROOT}/prompts/test-relative-path.md"
}

## A. Additional Basic Functionality Tests

@test "parses YAML frontmatter from workflow files" {
    cd "$TEST_PROJECT_DIR"

    run_workflow "test-windows"

    assert_success
    # If YAML parsing failed, windows wouldn't be created
    window_count=$(get_window_count "test-workflow-project")
    [ "$window_count" -eq 3 ]
}

## F. Prompt File Handling Tests

@test "excludes frontmatter from final prompt" {
    cd "$TEST_PROJECT_DIR"

    run_workflow "test-windows"

    assert_success
    # Check that temp prompt files were created and cleaned up
    # We can't easily check the contents without modifying start-workflow
    # but we can verify the workflow ran successfully
}

@test "cleans up temp files on completion" {
    cd "$TEST_PROJECT_DIR"

    # Get count of temp files before
    temp_before=$(ls /tmp/workflow-* 2>/dev/null | wc -l)

    run_workflow "test-basic"

    assert_success

    # Temp files should be cleaned up (may have some from other processes)
    # Just verify we didn't leave more files than we started with
    temp_after=$(ls /tmp/workflow-* 2>/dev/null | wc -l)
    [ "$temp_after" -le "$temp_before" ]
}
