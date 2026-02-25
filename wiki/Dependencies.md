# Dependencies

## Required Packages

| Package            | Purpose                |
|--------------------|------------------------|
| hyprland           | Window manager         |
| hyprpaper          | Wallpaper daemon       |
| dunst              | Notification daemon    |
| waybar             | Status bar             |
| rofi               | App launcher           |
| swayimg            | Image viewer           |
| ghostty            | Terminal               |
| dolphin            | File manager           |
| grim               | Screenshot tool        |
| slurp              | Area selector          |
| wl-clipboard       | Clipboard (wl-copy)    |
| jq                 | JSON parser            |
| curl               | HTTP requests (art-walls) |
| brightnessctl      | Brightness control     |
| playerctl          | Media player control   |
| pipewire + wpctl   | Volume control         |
| ttf-jetbrains-mono | Font (waybar & rofi)   |
| polkit-kde-agent    | Authentication prompts |
| obsidian            | Note-taking (AppImage) |

## Optional Packages

| Package            | Purpose                |
|--------------------|------------------------|
| exiftool           | Embed metadata in images (art-walls) |
| imagemagick        | Image width filtering (art-walls) |

## Install (openSUSE)

```bash
sudo zypper in hyprland hyprpaper waybar rofi swayimg dolphin \
    grim slurp wl-clipboard jq curl \
    brightnessctl playerctl pipewire wireplumber \
    google-noto-sans-mono-fonts exiftool ImageMagick
```

## Install (Arch)

```bash
sudo pacman -S hyprland hyprpaper waybar rofi swayimg dolphin \
    grim slurp wl-clipboard jq curl \
    brightnessctl playerctl pipewire wireplumber \
    ttf-jetbrains-mono polkit-kde-agent \
    perl-image-exiftool imagemagick
```

> ghostty may need to be installed from its own repo or built from source.
