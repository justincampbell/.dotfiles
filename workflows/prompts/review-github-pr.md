---
setup_tasks:
  - "./workflows/tasks/ensure-github-clone {{arg1}}"
  - "./workflows/tasks/checkout-github-pr {{arg1}}"
---

You're going to review a PR: {{arg1}}
We are on that branch in a git worktree, do not switch branches.
Do not make any write CLI/API requests using gh CLI or the GitHub API, unless I instruct you to do so.
If there are no concerns, approve the PR. Before approving, check if I have a pending review draft on the PR. If so, submit that pending review as the approval via the GitHub API instead of creating a new review. Otherwise, use `gh pr review --approve` with no body.

## Authored PRs

If I am the PR author, address feedback or fix CI as needed.
Use the `/ci-failures` skill to get details.

## xit spec PRs

If this is a PR that skips a flaky test (changes `it` to `xit`):
1. Approve the PR and mark it ready to merge (`gh pr merge --auto --squash`)
2. Create a Shortcut story using the `/shortcut` skill to fix the flaky test. Include the PR branch name as the merge base for the fix.
3. Spawn a worktree to work on the fix: `start-workflow --detached start-shortcut-story <shortcut-url>`
