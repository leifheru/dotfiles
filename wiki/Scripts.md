# Scripts

## art-walls.sh

**File:** `scripts/art-walls.sh`

Downloads high-quality artwork from official museum APIs with full metadata embedded into images. Sources are the **Metropolitan Museum of Art** and the **Art Institute of Chicago** — all public domain, CC0 licensed.

### Usage

```bash
# Random art (default: 1 image from MET)
./scripts/art-walls.sh -r

# Search for specific art
./scripts/art-walls.sh "monet"
./scripts/art-walls.sh -s aic "landscape"

# More images, custom destination
./scripts/art-walls.sh -r -n 10 -d ~/Wallpapers
```

### Options

| Flag | Description | Default |
|------|-------------|---------|
| `-r, --random` | Random art (no query needed) | off |
| `-s, --source` | `met` or `aic` | `met` |
| `-n, --count` | Number of images | `1` |
| `-d, --dest` | Save directory | `~/Pictures/walls` |
| `-w, --min-width` | Minimum width in px | `1920` |

### Features

- **Metadata embedding** via `exiftool` (title, artist, date, medium → EXIF/IPTC/XMP)
- **Sidecar `.txt`** files with full provenance, tags, museum URL
- **Naming:** `Artist - Title.jpg`
- **Dedup:** `.art-walls-history` file tracks downloads — never re-downloads the same artwork
- **Dependencies:** `curl`, `jq` (required), `exiftool` (optional), `imagemagick` (optional, for width filtering)

---

## set-wall.sh

**File:** `scripts/set-wall.sh`

Picks a random wallpaper from `~/Pictures/walls`, writes a `wallpaper {}` block to `hyprpaper.conf`, and restarts hyprpaper.

### Usage

```bash
# Use default wall directory
./scripts/set-wall.sh

# Custom directory
./scripts/set-wall.sh ~/Wallpapers
```

### How It's Used

| Trigger | Mechanism |
|---------|-----------|
| Login | `exec-once` in hyprland.conf |
| Daily | `systemd` user timer (`set-wall.timer`) |
| Manual | `SUPER + W` keybind |

### Systemd Timer

Files in `systemd/`:
- `set-wall.service` — runs the script
- `set-wall.timer` — fires daily + 5s after boot

Enable with:
```bash
ln -sf ~/Desktop/dotfiles/systemd/set-wall.service ~/.config/systemd/user/
ln -sf ~/Desktop/dotfiles/systemd/set-wall.timer   ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now set-wall.timer
```

---

## collect-walls.sh

**File:** `scripts/collect-walls.sh`

Recursively finds all images in a folder, copies them to a destination, renames them numerically (`1.png`, `2.jpg`, ...), and fixes permissions to `644`.

### Usage

```bash
# Default: ~/Pictures → ~/Pictures/walls
./scripts/collect-walls.sh

# Custom source and destination
./scripts/collect-walls.sh ~/Downloads/wallpapers ~/Pictures/walls
```

### Supported Formats

jpg, jpeg, png, webp, bmp, gif, tiff, svg, jxl

---

## Productivity Scripts

See [[Productivity]] for full details.

| Script | Keybind | Purpose |
|--------|---------|---------|
| `quick-capture.sh` | `Super + N` | Rofi popup → daily note |
| `pomodoro.sh` | `Super + B` | 25/5 timer for Waybar |
| `task-count.sh` | — | Waybar task counter |
| `remind.sh` | — | systemd morning/evening alerts |
| `focus-mode.sh` | `Super + Shift + F` | Distraction-free toggle |
