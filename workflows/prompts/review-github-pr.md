---
setup_tasks:
  - "./workflows/tasks/ensure-github-clone {{arg1}}"
  - "./workflows/tasks/checkout-github-pr {{arg1}}"
tmux_windows:
  - name: ai
    command: "{{ai_cli}}"
---

You're going to review a PR: {{arg1}}
We are on that branch in the main repository, do not switch branches.
Do not make any write CLI/API requests using gh CLI or the GitHub API, unless I instruct you to do so.

First, determine if I am the PR author, and then:
- If I am not the author: review the PR in detail
- If I am the author: address feedback (reviews or comments) and/or fix CI as needed

If there are no concerns, approve the PR via gh CLI without leaving a comment (use `gh pr review --approve` with no body).
