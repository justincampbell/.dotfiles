---
setup_tasks:
  - "./workflows/tasks/checkout-shortcut-story-worktree {{arg1}}"
---

You're going to work on a Shortcut story: {{arg1}}

Review the story details using the `$ short story [story ID]` CLI and come up with a plan for implementation.
We are on that branch in a git worktree, do not switch branches unless the story instructions say otherwise.
When you are done with the implementation, launch an Opus subagent to perform a code review.
