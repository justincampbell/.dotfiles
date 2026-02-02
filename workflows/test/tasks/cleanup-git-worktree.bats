#!/usr/bin/env bats

load ../test_helper

setup() {
    export TEST_DIR="$(mktemp -d)"
    export HOME="${TEST_DIR}/home"
    export CODE_DIR="${HOME}/Code"

    mkdir -p "${HOME}/Code/justincampbell"

    if [ -z "$REAL_HOME" ]; then
        export REAL_HOME="$HOME"
    fi

    # Create a real git repo for worktree testing
    mkdir -p "${CODE_DIR}/justincampbell/example"
    cd "${CODE_DIR}/justincampbell/example"
    git init . >/dev/null 2>&1
    echo "# Example Repo" > README.md
    git add README.md >/dev/null 2>&1
    git commit -m "Initial commit" >/dev/null 2>&1

    # Create main branch and set as default
    git branch -m main >/dev/null 2>&1 || true

    # Create a remote-like setup
    git remote add origin https://github.com/justincampbell/example.git >/dev/null 2>&1 || true
}

teardown() {
    cleanup_test_tmux_sessions

    # Clean up any worktrees we created
    if [ -d "${CODE_DIR}" ]; then
        find "${CODE_DIR}" -name "*.git" -type f | while read -r worktree_git; do
            worktree_dir=$(dirname "$worktree_git")
            git -C "${CODE_DIR}/justincampbell/example" worktree remove "$worktree_dir" --force 2>/dev/null || true
        done
    fi

    rm -rf "${TEST_DIR}"
}

@test "removes specified git worktree directory" {
    cd "${CODE_DIR}/justincampbell/example"

    # Create a worktree first
    worktree_path="${CODE_DIR}/justincampbell/example-test-cleanup"
    git worktree add "$worktree_path" -b test-cleanup >/dev/null 2>&1

    assert_directory_exists "$worktree_path"

    # Clean it up
    run_task cleanup-git-worktree "$worktree_path"

    assert_success
    # Worktree should no longer exist
    [ ! -d "$worktree_path" ]
}

@test "defaults to current directory when no argument provided" {
    cd "${CODE_DIR}/justincampbell/example"

    # Create a worktree
    worktree_path="${CODE_DIR}/justincampbell/example-test-default"
    git worktree add "$worktree_path" -b test-default >/dev/null 2>&1

    assert_directory_exists "$worktree_path"

    # Clean it up from within the worktree (no argument)
    cd "$worktree_path"
    run_task cleanup-git-worktree

    assert_success
    # Worktree should no longer exist
    [ ! -d "$worktree_path" ]
}

@test "kills associated tmux session if it exists" {
    cd "${CODE_DIR}/justincampbell/example"

    # Create a worktree
    worktree_path="${CODE_DIR}/justincampbell/example-test-session"
    git worktree add "$worktree_path" -b test-session >/dev/null 2>&1

    # Create a tmux session with the same name
    session_name=$(basename "$worktree_path")
    tmux new-session -d -s "$session_name" -c "$worktree_path"

    # Verify session exists
    tmux has-session -t "$session_name" 2>/dev/null

    # Clean up the worktree
    run_task cleanup-git-worktree "$worktree_path"

    assert_success
    # Session should no longer exist
    run tmux has-session -t "$session_name"
    assert_failure
}

@test "handles case when worktree doesn't exist (idempotent)" {
    cd "${CODE_DIR}/justincampbell/example"

    # Try to cleanup a non-existent worktree
    non_existent_path="${CODE_DIR}/justincampbell/example-nonexistent"

    run_task cleanup-git-worktree "$non_existent_path"

    assert_failure
    # Should fail because directory doesn't exist
}

@test "handles case when tmux session doesn't exist" {
    cd "${CODE_DIR}/justincampbell/example"

    # Create a worktree without a tmux session
    worktree_path="${CODE_DIR}/justincampbell/example-test-no-session"
    git worktree add "$worktree_path" -b test-no-session >/dev/null 2>&1

    # Clean up the worktree (no tmux session to kill)
    run_task cleanup-git-worktree "$worktree_path"

    assert_success
    assert_output --partial "No tmux session found"
}

@test "fails when trying to cleanup main repository" {
    cd "${CODE_DIR}/justincampbell/example"

    # Try to cleanup the main repo
    run_task cleanup-git-worktree "${CODE_DIR}/justincampbell/example"

    assert_failure
    assert_output --partial "Cannot cleanup main repository"
}

@test "fails gracefully when not a git directory" {
    mkdir -p "${TEST_DIR}/not-a-git-repo"

    run_task cleanup-git-worktree "${TEST_DIR}/not-a-git-repo"

    assert_failure
    assert_output --partial "not a git directory"
}

@test "does not delete the branch" {
    cd "${CODE_DIR}/justincampbell/example"

    # Create a worktree
    worktree_path="${CODE_DIR}/justincampbell/example-test-keep-branch"
    git worktree add "$worktree_path" -b test-keep-branch >/dev/null 2>&1

    # Verify branch exists
    git show-ref --verify --quiet "refs/heads/test-keep-branch"

    # Clean up the worktree
    run_task cleanup-git-worktree "$worktree_path"

    assert_success

    # Branch should still exist
    git show-ref --verify --quiet "refs/heads/test-keep-branch"
}
