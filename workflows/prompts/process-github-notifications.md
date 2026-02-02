---
setup_tasks:
  - "mktemp --directory --tmpdir=/tmp -t github-notifications"
tmux_session_name: "github-notifications"
tmux_windows:
  - name: ai
    command: "{{ai_cli}} && exit"
---

We will process GitHub notifications!
If the PR is merged or closed, and there's no further action needed (no mentions/comments), dismiss the notification.
If I have already reviewed the PR, dismiss the notification unless there are new changes.
If the notification is not a PR, open it in my browser with `open <NOTIFICATION-URL>` and let me dismiss it manually.

If the PR is ready for review and I have not reviewed it yet, start the review workflow.
- Launch the review workflow: `start-workflow review-github-pr <PR-URL>`
- Open the GitHub URL in my browser with `open <PR-URL>`
- Wait for my input to process the next notification.
