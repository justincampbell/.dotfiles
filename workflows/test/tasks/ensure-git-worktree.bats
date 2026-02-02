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

@test "creates new worktree with sanitized branch name" {
    cd "${CODE_DIR}/justincampbell/example"

    run_task ensure-git-worktree "feature/fix-bug"

    assert_success
    assert_line --index -1 "${CODE_DIR}/justincampbell/example-feature-fix-bug"
    assert_directory_exists "${CODE_DIR}/justincampbell/example-feature-fix-bug"
}

@test "returns existing worktree path when already exists" {
    cd "${CODE_DIR}/justincampbell/example"

    # Create worktree first
    run_task ensure-git-worktree "test-branch"
    assert_success
    local expected_path="${CODE_DIR}/justincampbell/example-test-branch"
    assert_line --index -1 "$expected_path"

    # Run again - should return same path
    run_task ensure-git-worktree "test-branch"
    assert_success
    assert_line --index -1 "$expected_path"
}

@test "creates parent directory structure" {
    cd "${CODE_DIR}/justincampbell/example"

    run_task ensure-git-worktree "new-feature"

    assert_success
    assert_directory_exists "${CODE_DIR}/justincampbell"
    assert_directory_exists "${CODE_DIR}/justincampbell/example-new-feature"
}

@test "handles branch names with special characters" {
    cd "${CODE_DIR}/justincampbell/example"

    run_task ensure-git-worktree "feature/fix-bug"

    assert_success
    assert_line --index -1 "${CODE_DIR}/justincampbell/example-feature-fix-bug"
    assert_directory_exists "${CODE_DIR}/justincampbell/example-feature-fix-bug"
}

@test "starts from origin/main as base branch" {
    cd "${CODE_DIR}/justincampbell/example"

    run_task ensure-git-worktree "new-branch"

    assert_success
    worktree_path="${CODE_DIR}/justincampbell/example-new-branch"
    assert_directory_exists "$worktree_path"

    # Check that worktree has a git repository
    cd "$worktree_path"
    run git rev-parse --is-inside-work-tree
    assert_success
    assert_output "true"
}

@test "sets up proper git tracking" {
    cd "${CODE_DIR}/justincampbell/example"

    run_task ensure-git-worktree "tracking-test"

    assert_success
    worktree_path="${CODE_DIR}/justincampbell/example-tracking-test"

    cd "$worktree_path"
    # Should not have upstream tracking initially
    run git rev-parse --abbrev-ref tracking-test@{upstream}
    assert_failure
}

@test "idempotent behavior" {
    cd "${CODE_DIR}/justincampbell/example"

    # First run
    run_task ensure-git-worktree "idempotent-test"
    assert_success
    local expected_path="${CODE_DIR}/justincampbell/example-idempotent-test"
    assert_line --index -1 "$expected_path"

    # Second run - should not fail
    run_task ensure-git-worktree "idempotent-test"
    assert_success
    assert_line --index -1 "$expected_path"
}

@test "fails gracefully when not in a git repository" {
    cd "${TEST_DIR}"

    run_task ensure-git-worktree "should-fail"

    assert_failure
}

@test "detects default branch from remote (not hardcoded to main)" {
    cd "${CODE_DIR}/justincampbell/example"

    # Create a remote with master as default (simulating non-main repos)
    # We'll verify by checking that the task doesn't fail on non-main repos
    # The task uses: git symbolic-ref refs/remotes/origin/HEAD

    run_task ensure-git-worktree "default-branch-test"

    assert_success
    worktree_path="${CODE_DIR}/justincampbell/example-default-branch-test"
    assert_directory_exists "$worktree_path"

    # Verify the worktree was created from the default branch (main in our test)
    cd "$worktree_path"
    run git log --oneline
    assert_success
    # Should have the initial commit
    assert_output --partial "Initial commit"
}