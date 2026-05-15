---
setup_tasks:
  - "./workflows/tasks/ensure-github-clone {{arg1}}"
tmux_windows:
  - name: ai
    command: "{{ai_cli}}"
  - name: revise
    command: "revise --dev"
---

You're exploring a GitHub repo: {{arg1}}

The repo has been cloned to `~/Code/[org]/[repo]` and we're in it. Take a look around and wait for further instructions.
