---
model: opus[1m]
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

You're going to review a PR: {{arg1}}
We are on that branch in a git worktree, do not switch branches.
Do not make any write CLI/API requests using gh CLI or the GitHub API, unless I instruct you to do so.

Review only the changes this PR introduces, not base-branch drift. First run `git fetch origin main`, then compare against the merge-base with `origin/main` using a three-dot diff: `git diff origin/main...HEAD`. Do not diff against local `main` (it may be stale) or against `origin/main` with two dots (that mixes in unrelated changes that landed on main after the branch point).

Do not approve the PR unless I tell you to. Do not leave comments on GitHub. Review the code locally and share your feedback with me here.
