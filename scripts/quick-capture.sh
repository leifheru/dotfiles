#!/usr/bin/env bash
# ─── Quick Capture ───
# Pops up a rofi prompt and appends the text to today's daily note.
# Usage: ./quick-capture.sh

set -euo pipefail

WIKI_DIR="$HOME/Desktop/dotfiles/wiki"
DAILY_DIR="$WIKI_DIR/daily"
TEMPLATE="$WIKI_DIR/templates/daily.md"
TODAY=$(date +%Y-%m-%d)
DAY_NAME=$(date +%A)
NOTE="$DAILY_DIR/$TODAY.md"

# Create daily dir if needed
mkdir -p "$DAILY_DIR"

# Create today's note from template if it doesn't exist
if [[ ! -f "$NOTE" ]]; then
    sed -e "s/{{date:YYYY-MM-DD}}/$TODAY/g" \
        -e "s/{{date:dddd}}/$DAY_NAME/g" \
        "$TEMPLATE" > "$NOTE"
fi

# Rofi prompt
CAPTURE=$(rofi -dmenu -p "capture" -theme-str '
window { width: 400px; }
listview { enabled: false; }
' 2>/dev/null) || exit 0

# Skip if empty
[[ -z "$CAPTURE" ]] && exit 0

# Append under Inbox section (create it if missing)
if grep -q "^## Inbox" "$NOTE"; then
    sed -i "/^## Inbox/a - $CAPTURE" "$NOTE"
else
    # Add Inbox section before Notes
    sed -i "/^## Notes/i ## Inbox\n- $CAPTURE\n" "$NOTE"
fi

notify-send "Captured" "$CAPTURE" -t 2000
