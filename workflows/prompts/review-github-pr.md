---
setup_tasks:
  - "./workflows/tasks/ensure-github-clone {{arg1}}"
  - "./workflows/tasks/checkout-github-pr {{arg1}}"
---

You're going to review a PR: {{arg1}}
We are on that branch in a git worktree, do not switch branches.
Do not make any write CLI/API requests using gh CLI or the GitHub API, unless I instruct you to do so.
Do not approve the PR unless I tell you to. Do not leave comments on GitHub. Review the code locally and share your feedback with me here.
