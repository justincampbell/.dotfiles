---
setup_tasks:
  - "echo {{arg1}}"
  - "echo {{arg2}}"
tmux_windows:
  - name: ai
    command: "{{ai_cli}}"
---

Test workflow with template variables {{arg1}} and {{arg2}}.
