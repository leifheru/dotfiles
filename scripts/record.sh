#!/bin/bash
# Toggle screen recording with wf-recorder
# Usage: record.sh [area]
#   no args  → record full screen
#   area     → record a selected area (via slurp)

DIR=~/Videos/recordings
mkdir -p "$DIR"

# If wf-recorder is already running, stop it
if pgrep -x wf-recorder > /dev/null; then
    pkill -SIGINT wf-recorder
    notify-send "Recording saved" "$DIR" -i video-x-generic
    exit 0
fi

FILENAME="$DIR/$(date +%Y%m%d_%H%M%S).webm"

if [ "$1" = "area" ]; then
    GEOMETRY=$(slurp)
    [ -z "$GEOMETRY" ] && exit 1
    wf-recorder -c libvpx -g "$GEOMETRY" -f "$FILENAME" &
else
    wf-recorder -c libvpx -f "$FILENAME" &
fi

notify-send "Recording started" "Press keybind again to stop" -i media-record
