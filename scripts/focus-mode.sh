#!/usr/bin/env bash
# ─── Focus Mode ───
# Toggles distraction-free mode: hides Waybar + fullscreens current window.
# Usage: focus-mode.sh

set -euo pipefail

STATE_FILE="/tmp/focus-mode"

if [[ -f "$STATE_FILE" ]]; then
    # Exit focus mode
    rm -f "$STATE_FILE"
    waybar &
    disown
    hyprctl dispatch fullscreen 1 >/dev/null 2>&1 || true
    notify-send "Focus Mode" "Off" -t 2000
else
    # Enter focus mode
    touch "$STATE_FILE"
    killall -q waybar || true
    hyprctl dispatch fullscreen 1 >/dev/null 2>&1 || true
    notify-send "Focus Mode" "On — Super+Shift+F to exit" -t 3000
fi
