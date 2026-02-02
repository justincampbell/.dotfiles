---
setup_tasks:
  - "./workflows/tasks/ensure-github-clone {{arg1}}"
  - "./workflows/tasks/checkout-github-pr-worktree {{arg1}}"
tmux_windows:
  - name: ai
    command: "{{ai_cli}} && cleanup-git-worktree"
---

You're going to review a PR: {{arg1}}
We are on that branch in a git worktree, do not switch branches.
Do not make any write CLI/API requests using gh CLI or the GitHub API, unless I instruct you to do so.
If I am the PR author, address feedback or fix CI as needed.
If there are no concerns, approve the PR via gh CLI without leaving a comment (use `gh pr review --approve` with no body).
