# Hyprpaper

**File:** `hypr/hyprpaper.conf`

## How It Works

Wallpaper is managed via `scripts/set-wall.sh` which writes a `wallpaper {}` block to `hyprpaper.conf` and restarts hyprpaper.

```conf
splash = false

wallpaper {
    monitor =
    path = ~/Pictures/walls/selected.jpg
    fit_mode = cover
}
```

- **`monitor =`** (empty) targets all monitors
- **`fit_mode = cover`** fills the screen, cropping if needed

## Wallpaper Rotation

| When | What |
|------|------|
| **Login** | Random wallpaper set via `exec-once` in hyprland.conf |
| **Daily** | systemd timer (`set-wall.timer`) changes it at midnight |
| **SUPER + W** | Instantly cycle to a new random wallpaper |

## Wallpaper Source

Use [[Scripts#art-walls.sh]] to download museum art directly to `~/Pictures/walls`:

```bash
art-walls.sh -r          # random museum art
art-walls.sh "starry"    # search by keyword
```

## Multi-Monitor

By default `monitor =` (empty) applies to all monitors. To target specific monitors, edit `set-wall.sh` to write separate blocks:

```conf
wallpaper {
    monitor = eDP-1
    path = ~/Pictures/walls/laptop.jpg
    fit_mode = cover
}

wallpaper {
    monitor = HDMI-A-1
    path = ~/Pictures/walls/external.jpg
    fit_mode = cover
}
```

## Manual Wallpaper

Edit `hypr/hyprpaper.conf` directly with the desired `wallpaper {}` block and restart hyprpaper:

```bash
killall hyprpaper; hyprpaper &
```
