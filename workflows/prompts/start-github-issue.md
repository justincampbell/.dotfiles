---
setup_tasks:
  - "./workflows/tasks/ensure-github-clone {{arg1}}"
  - "./workflows/tasks/checkout-github-issue {{arg1}}"
---

You're going to work on a GitHub issue: {{arg1}}

Review the issue details using `gh issue view` and come up with a plan for implementation.
We are on that branch in a git worktree, do not switch branches unless the issue instructions say otherwise.
When you are done with the implementation, launch an Opus subagent to perform a code review.
Use the `/justincampbell:open-pull-request` skill to open a PR.
Use `/loop` to wait for CI to complete using `gh pr checks --watch` (wrap in a retry loop in case it times out).
If CI fails, investigate the failures and fix them.
Rebase and push and wait for the next CI run to finish.
