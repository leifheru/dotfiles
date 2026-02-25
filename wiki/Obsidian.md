# Obsidian

**Config:** `wiki/.obsidian/` (inside the vault)

Note-taking app used to browse the dotfiles wiki.

## How Config Works

Obsidian stores its settings in a `.obsidian/` folder **inside the vault**, not in `~/.config/`. Since the vault is `~/Desktop/dotfiles/wiki`, the config is automatically tracked in the dotfiles repo at `wiki/.obsidian/`.

> `~/.config/obsidian/` is Electron app data (cache, cookies) — **not** your settings. Don't track it.

## Config Files

| File | Purpose |
|------|---------|
| `appearance.json` | Theme (dark), accent color |
| `app.json` | Editor settings (line numbers, spellcheck) |
| `core-plugins.json` | Enabled built-in plugins |
| `workspace.json` | Window layout (auto-managed) |

## Setup

- **AppImage** at `~/.local/bin/Obsidian.AppImage`
- **Desktop entry** at `~/.local/share/applications/obsidian.desktop` (shows in Rofi)
- **Icon** at `~/.local/share/icons/obsidian.png`

## Launch

```bash
Super + R → type "Obsidian" → Enter
```
