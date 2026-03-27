---
setup_tasks:
  - "./workflows/tasks/checkout-shortcut-story {{arg1}}"
---

You're going to work on a Shortcut story: {{arg1}}

Review the story details using the `$ short story [story ID]` CLI and come up with a plan for implementation.
We are on that branch in a git worktree, do not switch branches unless the story instructions say otherwise.
When you are done with the implementation, launch an Opus subagent to perform a code review.
Use the `/justincampbell:open-pull-request` skill to open a PR.
Use `/loop` to check CI periodically.
If CI fails, use the `/ci-failures` skill to get details and fix the failures.
Rebase and push and wait for the next CI run to finish.

# UI-facing work

Use Chrome MCP to validate any user-facing changes in the UI.
The database/other services are running in another worktree. You may need to run migrations, that's okay to do.
