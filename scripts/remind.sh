#!/usr/bin/env bash
# ─── Daily Reminders ───
# Sends a notification based on time of day.
# Called by systemd timer at morning and evening.

set -euo pipefail

HOUR=$(date +%H)

if (( HOUR < 12 )); then
    notify-send "Morning" "Plan your day — Super+D to open daily note" -t 10000
else
    notify-send "Evening" "Review your day — check off completed tasks" -t 10000
fi
