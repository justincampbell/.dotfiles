---
model: opus[1m]
setup_tasks:
  - "./workflows/tasks/ensure-github-clone $SHORTCUT_REPO_URL"
tmux_windows:
  - name: ai
    command: "{{ai_cli}}"
  - name: revise
    command: "revise --dev"
  - name: rename
    command: "rename-tmux-session && exit"
---

You're going to fix a Datadog error: {{arg1}}

## Step 1: Investigate the error

Extract the issue ID from the URL — it's the UUID path segment after `/error-tracking/issue/`.

Use the Datadog MCP `get_datadog_error_tracking_issue` tool to fetch the error details.
Then use `search_datadog_spans` to find recent traces with stack traces for this error.

Gather:
- Error message and type
- Stack trace
- Affected service/endpoint
- Frequency and impact (how many occurrences)

## Step 2: Create a Shortcut bug

Use the `/justincampbell:shortcut` skill to create a bug in the appropriate backlog epic.

The story should include:
- A clear title describing the error
- The Datadog error URL in the description
- Stack trace summary
- Frequency/impact data
- Your initial analysis of the root cause

## Step 3: Create the branch and worktree

After creating the Shortcut story, use the story's branch name to set up a worktree:

```
ensure-git-worktree sc-<story-id>-<slug>
```

The branch name must start with `sc-<story-id>-` followed by a slug of the story title.

Change into the worktree directory and do all further work there.

## Step 4: Fix the error

Based on your investigation:
1. Locate the relevant code from the stack trace
2. Understand the root cause
3. Implement the fix
4. Write or update tests to cover the error case

## Step 5: Open a PR and monitor

When you are done with the implementation, launch an Opus subagent to perform a code review.
Use the `/open-pull-request` skill to open a PR.
Include the Datadog error URL and Shortcut story link in the PR description.
Use the `/watch-pr` skill to monitor the PR for CI results and review feedback.
If CI fails, use the `/ci-failures` skill to get details and fix them.
After pushing fixes, immediately re-run `/watch-pr` to wait for the next state change — do this automatically, without asking. Keep looping until the PR is merged or closed.
## Step 6: Monitor the fix

Create a Datadog notebook tracking the error rate before and after deployment.

# UI-facing work

Use Chrome MCP to validate any user-facing changes in the UI.
Start the dev server if needed.
