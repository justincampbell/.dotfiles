#!/usr/bin/env bash

# Load BATS libraries
load "${BATS_TEST_DIRNAME}/../.bats/bats-support/load"
load "${BATS_TEST_DIRNAME}/../.bats/bats-assert/load"

# Export workflow paths
export WORKFLOW_ROOT="${BATS_TEST_DIRNAME}/../.."
export TASKS_DIR="${WORKFLOW_ROOT}/tasks"
export PROMPTS_DIR="${WORKFLOW_ROOT}/prompts"

# Helper functions for testing - defined before setup/teardown
cleanup_test_tmux_sessions() {
    # Kill any test tmux sessions with our test prefix
    tmux list-sessions 2>/dev/null | grep "^test-" | cut -d: -f1 | while read -r session; do
        tmux kill-session -t "$session" 2>/dev/null || true
    done
    # Also clean up example-based sessions from worktree tests
    tmux list-sessions 2>/dev/null | grep "^example-" | cut -d: -f1 | while read -r session; do
        tmux kill-session -t "$session" 2>/dev/null || true
    done
    # Clean up important-work test session
    tmux kill-session -t "important-work" 2>/dev/null || true
}

# Test setup
setup() {
    # Clean up any leftover test sessions from previous runs
    cleanup_test_tmux_sessions

    export TEST_DIR="$(mktemp -d)"
    export HOME="${TEST_DIR}/home"
    export CODE_DIR="${HOME}/Code"

    # Create test directory structure
    mkdir -p "${HOME}/Code/justincampbell"

    # Configure git for test commits
    git config --global user.name "Test User"
    git config --global user.email "test@example.com"

    # Copy real example repo for testing
    if [ -z "$REAL_HOME" ]; then
        export REAL_HOME="${HOME%/home}"  # Strip our test suffix
    fi

    if [ -d "$REAL_HOME/Code/justincampbell/example" ]; then
        cp -r "$REAL_HOME/Code/justincampbell/example" \
              "${CODE_DIR}/justincampbell/example"
    fi

    # Prevent tmux operations from affecting user's session by ensuring test isolation
    export TMUX=""  # Clear any existing tmux environment
}

teardown() {
    # Clean up any test tmux sessions we might have created
    cleanup_test_tmux_sessions

    # Remove test directory
    rm -rf "${TEST_DIR}"
}

# Assertion helpers
assert_tmux_session_exists() {
    local session_name="$1"
    tmux has-session -t "$session_name" 2>/dev/null || {
        echo "Expected tmux session '$session_name' to exist"
        echo "Current sessions:"
        tmux list-sessions 2>/dev/null || echo "No tmux sessions found"
        return 1
    }
}

assert_directory_exists() {
    local dir="$1"
    [[ -d "$dir" ]] || {
        echo "Expected directory to exist: $dir"
        echo "Directory contents of $(dirname "$dir"):"
        ls -la "$(dirname "$dir")" 2>/dev/null || echo "Parent directory does not exist"
        return 1
    }
}

assert_output_equals() {
    local expected="$1"
    [[ "$output" = "$expected" ]] || {
        echo "Output mismatch:"
        echo "Expected: '$expected'"
        echo "Actual:   '$output'"
        return 1
    }
}

# Run a workflow task safely (prevent tmux interference)
run_task() {
    local task_name="$1"
    shift

    # For tmux-related tasks, ensure we don't interfere with user sessions
    if [[ "$task_name" == *"tmux"* ]] || [[ "$task_name" == "start-workflow" ]]; then
        # Clear TMUX env to prevent nested session issues
        # Save original value, clear it, run the task, then restore
        local saved_tmux="${TMUX:-}"
        TMUX=""
        # Add --detached flag for ensure-tmux-session and start-workflow to prevent attach/switch
        if [[ "$task_name" == "ensure-tmux-session" ]] || [[ "$task_name" == "start-workflow" ]]; then
            run "${WORKFLOW_ROOT}/tasks/${task_name}" --detached "$@"
        else
            run "${WORKFLOW_ROOT}/tasks/${task_name}" "$@"
        fi
        TMUX="$saved_tmux"
    else
        run "${WORKFLOW_ROOT}/tasks/${task_name}" "$@"
    fi
}

# Helper to get window count in a session
get_window_count() {
    local session="$1"
    tmux list-windows -t "$session" 2>/dev/null | wc -l | tr -d ' '
}

# Helper to check if window exists in session
assert_window_exists() {
    local session="$1"
    local window_name="$2"
    tmux list-windows -t "$session" 2>/dev/null | grep -q "$window_name" || {
        echo "Expected window '$window_name' to exist in session '$session'"
        echo "Current windows:"
        tmux list-windows -t "$session" 2>/dev/null || echo "Session not found"
        return 1
    }
}