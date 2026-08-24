---
model: fable
effort: high
tmux_windows:
  - name: ai
    command: "{{ai_cli}}"
  - name: revise
    command: "revise --dev"
---

You're starting a planning session for a Shortcut entity: {{arg1}}

## First steps

1. Determine whether `{{arg1}}` is an **epic** or **objective** URL
2. Extract the entity ID from the URL
3. Fetch the entity data from the Shortcut API (see CLAUDE.md for commands)
4. For epics: also fetch stories
5. For objectives: fetch child epics
6. Create or update the folder note — `Epics/{id}-{slug}/{id}-{slug}.md` or `Objectives/{id}-{slug}/{id}-{slug}.md`; the directory already exists — using the templates in CLAUDE.md

## Gathering context

After creating/updating the README:

1. **Slack**: Use Slack MCP tools to search for discussions mentioning the epic/objective by name or ID. Look in relevant channels.
2. **Linked resources**: Extract any Google Docs, Figma, Loom, or other URLs from the Shortcut description and note them in the Resources section.
3. **Related epics**: For an epic, check if sibling epics under the same objective provide useful context.

## Shortcut writes

Do not post comments or otherwise write to Shortcut (story/epic/objective comments, description edits, state changes, owner changes, etc.) without explicit confirmation. Read-only operations are fine; for anything that would be visible to others, propose the change and wait for approval.
