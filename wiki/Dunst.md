# Dunst

**File:** `dunst/dunstrc`

Notification daemon — displays alerts from pomodoro, reminders, and other system notifications.

## Design

| Property     | Value            |
|--------------|------------------|
| Background   | `#000000`        |
| Text         | `#ffffff`        |
| Frame        | `#ffffff` 1px    |
| Font         | JetBrains Mono 11|
| Position     | Top-right        |
| Icons        | Disabled         |
| Corners      | Sharp            |

## Urgency Levels

| Level    | Text Color | Timeout   |
|----------|------------|-----------|
| Low      | `#888888`  | 4s        |
| Normal   | `#ffffff`  | 8s        |
| Critical | `#ffffff`  | Persistent|

## Test

```bash
notify-send "Test" "Hello from dunst"
notify-send -u critical "Critical" "This stays until dismissed"
```
