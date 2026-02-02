---
setup_tasks:
  - "./workflows/tasks/ensure-github-clone {{arg1}}"
  - "./workflows/tasks/checkout-github-issue {{arg1}}"
tmux_windows:
  - name: ai
    command: "{{ai_cli}}"
  - name: vim
    command: "vim ."
  - name: shell
    command: ""
---

You're going to work on a GitHub issue: {{arg1}}

Review the issue details using `gh issue view` and come up with a plan for implementation.
We are on that branch in the main repository, do not switch branches.
