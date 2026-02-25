# Waybar

**Files:** `waybar/config.jsonc` + `waybar/style.css`

## Design

| Property   | Value                         |
|------------|-------------------------------|
| Theme      | Pure black, white text        |
| Position   | Top, 28px                     |
| Font       | JetBrains Mono 12px           |
| Icons      | None — text only              |
| Borders    | None                          |

## Layout

```
[ 1 2 3 ]              [ 03:20 ]              [ vol 75   net   85+ ]
```

## Modules

| Module     | Format          | Example     |
|------------|-----------------|-------------|
| Workspaces | `{id}`          | `1 2 3`     |
| Clock      | `%H:%M`        | `03:20`     |
| Clock alt  | `%a %d %b`     | `Mon 24 Feb`|
| Volume     | `vol {volume}`  | `vol 75`    |
| Volume     | `mute` (muted)  | `mute`      |
| Network    | `{essid}`       | `MyWiFi`    |
| Battery    | `{capacity}`    | `85`        |
| Charging   | `{capacity}+`   | `45+`       |

Click clock to toggle between time and date.

## Custom Modules

| Module     | Script            | Purpose         |
|------------|-------------------|-----------------|
| Tasks      | `task-count.sh`   | Uncompleted task count from daily note |
| Pomodoro   | `pomodoro.sh`     | 25/5 work timer |

## Battery States

| State        | Style                |
|--------------|----------------------|
| Normal       | White text           |
| Warning ≤20% | Gray `#888888`      |
| Critical ≤10%| White on dark bg    |
