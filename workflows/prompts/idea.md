---
model: opus[1m]
tmux_windows:
  - name: ai
    command: "{{ai_cli}}"
  - name: revise
    command: "revise --dev"
  - name: rename
    command: "rename-tmux-session && exit"
---
You're going to explore an idea:

{{arg1}}

This is an open-ended, exploratory session — the idea might be a question to research, something to prototype locally, or a change to implement. Figure out which it is first, then:

- **Question / research** — investigate and report back what you found. You don't need to write any code.
- **Build / try something** — sketch a short plan, make the change, and validate it locally: run it, write and run the relevant tests, and use Chrome MCP for any user-facing changes (start the dev server if needed).

You're on a fresh branch in a git worktree, so experiment freely — do not switch branches.

Unlike the other workflows, this one is **exploratory and not autopilot**: do NOT open a pull request, push, or start the CI/merge flow on your own. When you've finished the work, summarize what you found or changed and stop for my review.

Only when I explicitly ask you to ship it should you:
- Launch an Opus subagent to perform a code review.
- Use the `/open-pull-request` skill to open a PR.
- Use the `/watch-pr` skill to monitor the PR for CI results and review feedback; if CI fails, use the `/ci-failures` skill to get details and fix them, then immediately re-run `/watch-pr` and keep looping until the PR is merged or closed.
