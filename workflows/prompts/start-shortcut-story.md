---
model: opus[1m]
setup_tasks:
  - "./workflows/tasks/checkout-shortcut-story {{arg1}}"
tmux_windows:
  - name: ai
    command: "{{ai_cli}}"
  - name: revise
    command: "revise --dev"
  - name: rename
    command: "rename-tmux-session && exit"
---

You're going to work on a Shortcut story: {{arg1}}

Review the story details using the `$ short story [story ID]` CLI and come up with a plan for implementation.
We are on that branch in a git worktree, do not switch branches unless the story instructions say otherwise.
When you are done with the implementation, launch an Opus subagent to perform a code review.
Use the `/open-pull-request` skill to open a PR.
Use the `/watch-pr` skill to monitor the PR for CI results and review feedback.
If CI fails, use the `/ci-failures` skill to get details and fix them.
After pushing fixes, immediately re-run `/watch-pr` to wait for the next state change — do this automatically, without asking. Keep looping until the PR is merged or closed.
# UI-facing work

Use Chrome MCP to validate any user-facing changes in the UI.
Start the dev server if needed.
