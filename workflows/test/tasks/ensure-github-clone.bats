#!/usr/bin/env bats

load ../test_helper

@test "returns existing repository path when repo exists" {
    mkdir -p "${CODE_DIR}/justincampbell/example"
    cd "${CODE_DIR}/justincampbell/example"
    git init . && echo "# Test" > README.md && git add . && git commit -m "test" >/dev/null 2>&1

    run_task ensure-github-clone "https://github.com/justincampbell/example"

    assert_success
    assert_line --index -1 "${CODE_DIR}/justincampbell/example"
}

@test "handles repository URLs without .git extension" {
    run_task ensure-github-clone "https://github.com/justincampbell/example"

    assert_success
    assert_line --index -1 "${CODE_DIR}/justincampbell/example"
}

@test "handles repository URLs with .git extension" {
    run_task ensure-github-clone "https://github.com/justincampbell/example.git"

    assert_success
    assert_line --index -1 "${CODE_DIR}/justincampbell/example"
}

@test "handles PR URLs by extracting repo info" {
    run_task ensure-github-clone "https://github.com/justincampbell/example/pull/123"

    assert_success
    assert_line --index -1 "${CODE_DIR}/justincampbell/example"
}

@test "handles issue URLs by extracting repo info" {
    run_task ensure-github-clone "https://github.com/justincampbell/example/issues/456"

    assert_success
    assert_line --index -1 "${CODE_DIR}/justincampbell/example"
}

@test "creates parent directories" {
    rm -rf "${CODE_DIR}/justincampbell"

    run_task ensure-github-clone "https://github.com/justincampbell/example"

    assert_success
    assert_directory_exists "${CODE_DIR}/justincampbell"
}

@test "fails with invalid GitHub URL" {
    run_task ensure-github-clone "not-a-github-url"

    assert_failure
    assert_line --partial "Invalid GitHub URL format"
}

@test "handles SSH GitHub URLs" {
    run_task ensure-github-clone "git@github.com:justincampbell/example.git"

    assert_success
    assert_line --index -1 "${CODE_DIR}/justincampbell/example"
}

@test "idempotent - running twice returns same path" {
    run_task ensure-github-clone "https://github.com/justincampbell/example"
    assert_success
    local expected_path="${CODE_DIR}/justincampbell/example"
    assert_line --index -1 "$expected_path"

    run_task ensure-github-clone "https://github.com/justincampbell/example"
    assert_success
    assert_line --index -1 "$expected_path"
    assert_line --partial "Repository already exists"
}