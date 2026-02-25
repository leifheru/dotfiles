# Productivity

Tools for staying focused and organized — all integrated into the desktop.

## Quick Reference

| Keybind | Action |
|---------|--------|
| `Super + N` | Quick capture (rofi popup → daily note) |
| `Super + D` | Open today's daily note in Obsidian |
| `Super + B` | Start pomodoro (25 min) |
| `Super + Shift + B` | Stop pomodoro |
| `Super + Shift + F` | Toggle focus mode |

## Daily Notes

Created automatically in `wiki/daily/YYYY-MM-DD.md` using the template from `wiki/templates/daily.md`.

Sections:
- **Tasks** — checkbox list for the day
- **Inbox** — quick captures land here (via `Super + N`)
- **Notes** — freeform writing
- **End of Day** — reflection prompts

## Quick Capture

Press `Super + N` anywhere → type a thought → it's appended to today's daily note under **Inbox**.

**Script:** `scripts/quick-capture.sh`

## Pomodoro Timer

25 min work → 5 min break cycle, shown in Waybar.

| State | Waybar Display |
|-------|---------------|
| Working | `18:42` (white) |
| Break | `brk 03:21` (gray) |
| Idle | hidden |

Notifications fire when work/break sessions end.

**Script:** `scripts/pomodoro.sh`

## Task Counter

Shows uncompleted task count from today's daily note in Waybar.

| State | Display |
|-------|---------|
| Tasks remaining | `3` (white) |
| All done | `done` (dim) |
| No daily note | hidden |

**Script:** `scripts/task-count.sh`

## Daily Reminders

systemd timer fires at **9:00** and **18:00**:
- Morning: "Plan your day"
- Evening: "Review your day"

**Files:** `systemd/remind.service` + `systemd/remind.timer`

Enable: `systemctl --user enable --now remind.timer`

## Focus Mode

Toggles distraction-free mode:
- Hides Waybar
- Fullscreens current window
- Press `Super + Shift + F` again to exit

**Script:** `scripts/focus-mode.sh`
