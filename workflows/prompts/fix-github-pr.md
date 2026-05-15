---
setup_tasks:
  - "./workflows/tasks/ensure-github-clone {{arg1}}"
  - "./workflows/tasks/checkout-github-pr {{arg1}}"
tmux_windows:
  - name: ai
    command: "{{ai_cli}}"
  - name: revise
    command: "revise --dev"
  - name: rename
    command: "rename-tmux-session && exit"
---

You're going to fix issues on a PR: {{arg1}}
We are on that branch in a git worktree, do not switch branches.

Check CI status for the PR and fix any failures. Look for available skills (like `/ci-failures`) that can help fetch CI details.
Check for review comments on the PR and address them.
Push fixes to the branch when done.
