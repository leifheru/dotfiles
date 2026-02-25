#!/usr/bin/env bash
# ─── Task Counter ───
# Counts uncompleted tasks in today's daily note for Waybar.
# Usage: task-count.sh

set -euo pipefail

TODAY=$(date +%Y-%m-%d)
NOTE="$HOME/Desktop/dotfiles/wiki/daily/$TODAY.md"

if [[ ! -f "$NOTE" ]]; then
    echo '{"text": "", "class": "empty", "alt": "empty"}'
    exit 0
fi

COUNT=$(grep -c '^\- \[ \]' "$NOTE" 2>/dev/null || echo 0)

if (( COUNT == 0 )); then
    echo '{"text": "done", "class": "done", "alt": "done"}'
else
    echo "{\"text\": \"$COUNT\", \"class\": \"active\", \"alt\": \"active\", \"tooltip\": \"$COUNT tasks remaining\"}"
fi
