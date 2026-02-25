# Hyprland

**File:** `hypr/hyprland.conf`

Single-file config — everything in one place.

## Design

| Property        | Value                 |
|-----------------|-----------------------|
| Theme           | Pure black & white    |
| Layout          | Dwindle               |
| Gaps            | 0 (edge-to-edge)     |
| Borders         | 1px, sharp corners    |
| Active border   | `#ffffff`             |
| Inactive border | `#1a1a1a`             |
| Animations      | Disabled              |
| Blur / Shadow   | Disabled              |

## Default Programs

| Variable       | Program         |
|----------------|-----------------|
| `$terminal`    | ghostty         |
| `$fileManager` | dolphin         |
| `$menu`        | rofi -show drun |

## Autostart

| Process            | Purpose                |
|--------------------|------------------------|
| `waybar`           | Status bar             |
| `dunst`            | Notification daemon    |
| `set-wall.sh`      | Random wallpaper + starts hyprpaper |
| `hyprpolkitagent`  | Polkit authentication  |

## Cursor

Fixes GTK cursor warnings:

```conf
cursor {
    no_hardware_cursors = true
}
env = XCURSOR_SIZE, 24
env = XCURSOR_THEME, Adwaita
```

Also required once: `gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'`

## Monitor

```conf
monitor = , preferred, auto, 1
```

For manual setup: `monitor = eDP-1, 1920x1200@60, 0x0, 1.25`

## Keybinds

**Modifier:** `SUPER`

### General

| Keybind     | Action            |
|-------------|-------------------|
| `Super + Q` | Open terminal     |
| `Super + C` | Close window      |
| `Super + M` | Exit Hyprland     |
| `Super + E` | File manager      |
| `Super + R` | Rofi launcher     |
| `Super + V` | Toggle floating   |
| `Super + F` | Fullscreen        |
| `Super + P` | Pseudo-tile       |
| `Super + T` | Toggle split      |
| `Super + W` | Random wallpaper  |
| `Super + N` | Quick capture     |
| `Super + D` | Open daily note   |
| `Super + B` | Start pomodoro    |
| `Super + Shift + B` | Stop pomodoro |
| `Super + Shift + F` | Focus mode    |

### Focus (vim motions)

| Keybind       | Action       |
|---------------|-------------|
| `Super + H`   | Focus left  |
| `Super + J`   | Focus down  |
| `Super + K`   | Focus up    |
| `Super + L`   | Focus right |

### Move Windows (vim motions)

| Keybind             | Action       |
|---------------------|-------------|
| `Super + Shift + H` | Move left   |
| `Super + Shift + J` | Move down   |
| `Super + Shift + K` | Move up     |
| `Super + Shift + L` | Move right  |

### Workspaces

| Keybind                  | Action                   |
|--------------------------|--------------------------|
| `Super + 1-9, 0`        | Switch workspace         |
| `Super + Shift + 1-9, 0`| Move window to workspace |
| `Super + S`              | Toggle scratchpad        |
| `Super + Shift + S`      | Move to scratchpad       |

### Mouse

| Keybind            | Action        |
|--------------------|---------------|
| `Super + LMB drag` | Move window   |
| `Super + RMB drag` | Resize window |
| `Super + Scroll`   | Cycle workspaces |

### Screenshots

Uses `grim` + `slurp` + `wl-copy`. Saved to `~/Pictures/screenshots/` with timestamp filenames and auto-copied to clipboard.

| Keybind                | Action              |
|------------------------|---------------------|
| `Print`                | Full screen          |
| `Super + Print`        | Select area          |
| `Super + Shift + Print`| Active window only   |

Media keys (volume, brightness, playerctl) are bound to `XF86` hardware keys.
