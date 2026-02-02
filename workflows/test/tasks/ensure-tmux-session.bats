#!/usr/bin/env bats

load ../test_helper

# Save original TMUX value before setup clears it
export ORIGINAL_TMUX="${TMUX:-}"

# Override setup to create safe test directories with predictable names
setup() {
    # Clean up any leftover test sessions from previous runs
    cleanup_test_tmux_sessions

    export TEST_DIR="$(mktemp -d)"
    export HOME="${TEST_DIR}/home"
    export CODE_DIR="${HOME}/Code"

    mkdir -p "${HOME}/Code/test-org"

    # Clear tmux environment to prevent interference
    export TMUX=""

    # Create a test directory with a safe, predictable name
    export TEST_PROJECT_DIR="${CODE_DIR}/test-org/test-project"
    mkdir -p "$TEST_PROJECT_DIR"

    if [ -z "$REAL_HOME" ]; then
        export REAL_HOME="${HOME%/home}"
    fi
}

teardown() {
    cleanup_test_tmux_sessions
    rm -rf "${TEST_DIR}"
}

@test "creates new tmux session with specified name" {
    run_task ensure-tmux-session "$TEST_PROJECT_DIR"

    assert_success
    assert_line --index -1 "test-project"

    # Verify session exists
    tmux has-session -t "test-project"
}

@test "returns early when session already exists" {
    # Create a separate test directory
    mkdir -p "${CODE_DIR}/test-org/test-existing"

    # Create session first
    tmux new-session -d -s "test-existing" -c "${CODE_DIR}/test-org/test-existing"

    run_task ensure-tmux-session "${CODE_DIR}/test-org/test-existing"

    assert_success
    assert_line --partial "Session test-existing already exists"

    # Clean up
    tmux kill-session -t "test-existing" 2>/dev/null || true
}

@test "creates session in specified directory" {
    run_task ensure-tmux-session "$TEST_PROJECT_DIR"

    assert_success

    # Check that session is in correct directory
    # Use pwd -P to resolve symlinks and /private prefix on macOS
    session_pwd=$(tmux display-message -t "test-project" -p "#{pane_current_path}")
    expected_dir=$(cd "$TEST_PROJECT_DIR" && pwd -P)

    [ "$session_pwd" = "$expected_dir" ]

    # Clean up
    tmux kill-session -t "test-project" 2>/dev/null || true
}

@test "creates session with default window" {
    run_task ensure-tmux-session "$TEST_PROJECT_DIR"

    assert_success

    # Check that default 3 windows exist (ai,vim,shell)
    # Note: tmux may auto-rename windows based on running process
    window_count=$(tmux list-windows -t "test-project" | wc -l)
    [ "$window_count" -eq 3 ]

    # Verify session has expected number of windows
    tmux list-windows -t "test-project"

    # Clean up
    tmux kill-session -t "test-project" 2>/dev/null || true
}

@test "handles session names with safe characters" {
    # Create directory with hyphens (should be safe)
    safe_dir="${CODE_DIR}/test-org/test-safe-name"
    mkdir -p "$safe_dir"

    run_task ensure-tmux-session "$safe_dir"

    assert_success
    assert_line --index -1 "test-safe-name"

    tmux has-session -t "test-safe-name"

    # Clean up
    tmux kill-session -t "test-safe-name" 2>/dev/null || true
}

@test "works when tmux server not running" {
    # Skip this test if we're currently inside tmux to avoid killing user's session
    if [ -n "${ORIGINAL_TMUX}" ]; then
        skip "Cannot test tmux server restart while inside tmux (would kill your session)"
    fi

    # Kill tmux server if running (will restart automatically)
    tmux kill-server 2>/dev/null || true

    run_task ensure-tmux-session "$TEST_PROJECT_DIR"

    assert_success
    assert_line --index -1 "test-project"

    # Clean up
    tmux kill-session -t "test-project" 2>/dev/null || true
}

@test "does not interfere with existing sessions" {
    # Create a session with user-like name first
    tmux new-session -d -s "important-work" -c "$HOME"

    run_task ensure-tmux-session "$TEST_PROJECT_DIR"

    assert_success

    # Verify both sessions exist
    tmux has-session -t "important-work"
    tmux has-session -t "test-project"

    # Clean up
    tmux kill-session -t "test-project" 2>/dev/null || true
    tmux kill-session -t "important-work" 2>/dev/null || true
}

@test "handles nested tmux scenarios safely" {
    # Simulate being inside tmux by setting TMUX env var
    export TMUX="/tmp/tmux-501/default,12345,0"

    run_task ensure-tmux-session "$TEST_PROJECT_DIR"

    assert_success
    # Should still create session even if we're "inside" tmux
    tmux has-session -t "test-project"

    # Clean up
    tmux kill-session -t "test-project" 2>/dev/null || true
}