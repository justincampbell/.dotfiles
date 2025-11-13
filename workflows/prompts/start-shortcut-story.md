---
setup_tasks:
  - "./workflows/tasks/checkout-shortcut-story {{arg1}}"
tmux_windows:
  - name: ai
    command: "{{ai_cli}}"
  - name: vim
    command: "vim ."
  - name: shell
    command: ""
---

You're going to work on a Shortcut story: {{arg1}}

Review the story details using the `short` CLI and come up with a plan for implementation.
We are on that branch in the main repository, do not switch branches.
