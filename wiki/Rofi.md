# Rofi

**File:** `rofi/config.rasi`

> Uses `@theme "/dev/null"` to disable rofi's built-in theme before applying custom styling.

## Design

| Property   | Value                           |
|------------|---------------------------------|
| Theme      | Pure black `#000000`            |
| Icons      | Disabled                        |
| Prompt     | Hidden                          |
| Corners    | Sharp                           |
| Width      | 360px                           |
| Lines      | 10 visible                      |
| Font       | JetBrains Mono 11               |
| Unselected | Dim gray `#555555`              |
| Selected   | White text on `#1a1a1a`         |
| Separator  | 1px line between input and list |

## Modes

| Mode | Description          |
|------|----------------------|
| drun | Desktop applications |
| run  | Shell commands       |

## Usage

```bash
rofi -show drun    # app launcher (Super+R)
rofi -show run     # commands
```
