---
setup_tasks:
  - "./workflows/tasks/ensure-github-clone {{arg1}}"
  - "./workflows/tasks/checkout-github-pr {{arg1}}"
tmux_windows:
  - name: ai
    command: "{{ai_cli}} && cleanup-git-worktree"
---

You're going to review a PR: {{arg1}}
We are on that branch, do not switch branches.
Do not make any write CLI/API requests using gh CLI or the GitHub API.
