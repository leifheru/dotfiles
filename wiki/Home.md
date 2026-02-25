# Dotfiles Wiki

> Minimal black & white Hyprland desktop environment.
> All configs live in `~/Desktop/dotfiles/` and are symlinked to `~/.config/`.

## Pages

- [[Hyprland]] — Window manager config, keybinds, styling
- [[Waybar]] — Status bar modules & styling
- [[Rofi]] — App launcher
- [[Hyprpaper]] — Wallpaper daemon & daily rotation
- [[Dunst]] — Notification daemon
- [[Swayimg]] — Image viewer with vim keybinds
- [[Obsidian]] — Note-taking app & wiki viewer
- [[Productivity]] — Pomodoro, daily notes, focus mode
- [[Scripts]] — Utility scripts (art downloader, wallpaper rotation)
- [[Troubleshooting]] — Common issues & fixes
- [[Dependencies]] — Required packages

## Directory Structure

```
dotfiles/
├── hypr/
│   ├── hyprland.conf
│   └── hyprpaper.conf
├── waybar/
│   ├── config.jsonc
│   └── style.css
├── rofi/
│   └── config.rasi
├── dunst/
│   └── dunstrc
├── swayimg/
│   └── config
├── scripts/
│   ├── art-walls.sh        # download museum art w/ metadata
│   ├── set-wall.sh         # set random wallpaper via hyprpaper
│   ├── collect-walls.sh    # collect & rename wallpapers
│   ├── quick-capture.sh    # rofi → daily note
│   ├── pomodoro.sh         # 25/5 timer for Waybar
│   ├── task-count.sh       # task counter for Waybar
│   ├── remind.sh           # morning/evening nudges
│   └── focus-mode.sh       # distraction-free toggle
├── systemd/
│   ├── set-wall.service    # wallpaper rotation service
│   ├── set-wall.timer      # daily trigger
│   ├── remind.service      # reminder service
│   └── remind.timer        # 9am + 6pm trigger
├── ghostty/
│   └── config
└── zed/
    ├── settings.json
    └── keymap.json
```

> Obsidian config lives in `wiki/.obsidian/` (vault-based, no symlink needed).

## Symlinks

```bash
ln -sf ~/Desktop/dotfiles/hypr       ~/.config/hypr
ln -sf ~/Desktop/dotfiles/waybar     ~/.config/waybar
ln -sf ~/Desktop/dotfiles/rofi       ~/.config/rofi
ln -sf ~/Desktop/dotfiles/dunst      ~/.config/dunst
ln -sf ~/Desktop/dotfiles/swayimg    ~/.config/swayimg
ln -sf ~/Desktop/dotfiles/ghostty    ~/.config/ghostty
ln -sf ~/Desktop/dotfiles/zed        ~/.config/zed

# Systemd user units
ln -sf ~/Desktop/dotfiles/systemd/set-wall.service ~/.config/systemd/user/
ln -sf ~/Desktop/dotfiles/systemd/set-wall.timer   ~/.config/systemd/user/
ln -sf ~/Desktop/dotfiles/systemd/remind.service   ~/.config/systemd/user/
ln -sf ~/Desktop/dotfiles/systemd/remind.timer     ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now set-wall.timer
systemctl --user enable --now remind.timer
```
