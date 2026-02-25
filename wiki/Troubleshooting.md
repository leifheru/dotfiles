# Troubleshooting

## Cursor theme warnings

**Symptom:** `Unable to load hand2 from the cursor theme`

**Fix:**

```bash
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
gsettings set org.gnome.desktop.interface cursor-size 24
```

And ensure `hyprland.conf` has:

```conf
cursor {
    no_hardware_cursors = true
}
env = XCURSOR_THEME, Adwaita
```

## Waybar not updating

Restart after config changes:

```bash
killall waybar && waybar &
```

## Hyprland env vars not applying

Environment variables and cursor settings require a **full Hyprland restart** (re-login). A config reload (`hyprctl reload`) is not enough for `env` lines.

## Wallpaper not showing

Make sure `hyprpaper.conf` has a valid `wallpaper {}` block with a correct image path. Run `set-wall.sh` to regenerate it, or restart hyprpaper manually: `killall hyprpaper; hyprpaper &`. See [[Hyprpaper]].
