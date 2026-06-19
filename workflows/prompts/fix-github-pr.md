---
model: opus
effort: low
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
If the PR has merge conflicts with the base branch, rebase on `origin/main` and resolve the conflicts automatically — don't prompt.
Push fixes to the branch when done.

Then use the `/watch-pr` skill to monitor the PR for CI results, review feedback, and merge conflicts.
After pushing fixes, immediately re-run `/watch-pr` to wait for the next state change — do this automatically, without asking. Keep looping until the PR is merged or closed.
