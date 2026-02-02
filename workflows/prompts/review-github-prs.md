---
setup_tasks:
  - "mktemp --directory --tmpdir=/tmp -t github-pull-requests"
tmux_session_name: "github-pull-requests"
tmux_windows:
  - name: ai
    command: "{{ai_cli}} && exit"
---

Look for GitHub pull requests to review!
Start with PRs that:
- Are from my team
- Were created recently
- Are smaller in size
- Have passed all checks

Do not review PRs that:
- I have already reviewed
- Are not marked as ready for review

In order to review a PR:
- Launch the review workflow: `start-workflow review-github-pr <PR-URL>`
- Open the GitHub URL in my browser with `open <PR-URL>`
- Wait for my input to process the next PR
