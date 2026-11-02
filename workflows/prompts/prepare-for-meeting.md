---
model: opus
tmux_windows:
  - name: ai
    command: "{{ai_cli}}"
---

Help me prepare for this meeting: {{arg1}}

The local calendar is readable via `icalbuddy`; the URL's `eid` is base64 of `<event-id> <organizer-email>` if you need it. File the prep doc per this vault's `CLAUDE.md` conventions.

Don't post to Slack or the calendar invite without confirming first.
