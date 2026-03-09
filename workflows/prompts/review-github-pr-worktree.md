---
setup_tasks:
  - "./workflows/tasks/ensure-github-clone {{arg1}}"
  - "./workflows/tasks/checkout-github-pr-worktree {{arg1}}"
---

You're going to review a PR: {{arg1}}
We are on that branch in a git worktree, do not switch branches.
Do not make any write CLI/API requests using gh CLI or the GitHub API, unless I instruct you to do so.
If I am the PR author, address feedback or fix CI as needed.
If there are no concerns, approve the PR. Before approving, check if I have a pending review draft on the PR. If so, submit that pending review as the approval via the GitHub API instead of creating a new review. Otherwise, use `gh pr review --approve` with no body.
