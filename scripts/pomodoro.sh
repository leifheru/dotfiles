#!/usr/bin/env bash
# ─── Pomodoro Timer ───
# Simple pomodoro timer with Waybar JSON output.
# Usage: pomodoro.sh start|stop|status

set -euo pipefail

STATE_FILE="/tmp/pomodoro"
WORK_MIN=25
BREAK_MIN=5

start() {
    local end_ts=$(( $(date +%s) + WORK_MIN * 60 ))
    echo "$end_ts work" > "$STATE_FILE"
    notify-send "Pomodoro" "Work session started — ${WORK_MIN} min" -t 3000
}

stop() {
    rm -f "$STATE_FILE"
    notify-send "Pomodoro" "Timer stopped" -t 2000
}

status() {
    if [[ ! -f "$STATE_FILE" ]]; then
        echo '{"text": "", "class": "idle", "alt": "idle"}'
        return
    fi

    read -r end_ts mode < "$STATE_FILE"
    local now=$(date +%s)
    local remaining=$(( end_ts - now ))

    if (( remaining <= 0 )); then
        if [[ "$mode" == "work" ]]; then
            # Work done → switch to break
            local break_end=$(( now + BREAK_MIN * 60 ))
            echo "$break_end break" > "$STATE_FILE"
            notify-send "Pomodoro" "Work done! Take a ${BREAK_MIN} min break" -t 5000
            remaining=$(( BREAK_MIN * 60 ))
            mode="break"
        else
            # Break done
            rm -f "$STATE_FILE"
            notify-send "Pomodoro" "Break over — ready for next session" -t 5000
            echo '{"text": "", "class": "idle", "alt": "idle"}'
            return
        fi
    fi

    local min=$(( remaining / 60 ))
    local sec=$(( remaining % 60 ))
    local label
    if [[ "$mode" == "work" ]]; then
        label=$(printf "%02d:%02d" "$min" "$sec")
    else
        label=$(printf "brk %02d:%02d" "$min" "$sec")
    fi

    echo "{\"text\": \"$label\", \"class\": \"$mode\", \"alt\": \"$mode\"}"
}

case "${1:-status}" in
    start) start ;;
    stop)  stop  ;;
    status) status ;;
    *) echo "Usage: $0 start|stop|status" >&2; exit 1 ;;
esac
