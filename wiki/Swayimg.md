# Swayimg

**File:** `swayimg/config`

Image viewer with vim-style keybindings.

## Design

| Property      | Value |
|---------------|-------|
| Window bg     | `#000000` |
| Scale         | Fit   |
| Antialiasing  | Yes   |

## Keybinds

### Navigation

| Key        | Action         |
|------------|----------------|
| `h` / `k`  | Previous image |
| `l` / `j`  | Next image     |

### Zoom

| Key | Action       |
|-----|-------------|
| `+` | Zoom in 10% |
| `-` | Zoom out 10%|
| `0` | Fit window  |
| `a` | Actual size |
| `w` | Fit         |
| `e` | Fill        |

### Pan

| Key         | Action   |
|-------------|----------|
| `Shift + h` | Pan left |
| `Shift + l` | Pan right|
| `Shift + k` | Pan up   |
| `Shift + j` | Pan down |

### Transform

| Key         | Action         |
|-------------|----------------|
| `r`         | Rotate right   |
| `Shift + r` | Rotate left    |
| `f`         | Flip horizontal|
| `Shift + f` | Flip vertical  |

### Other

| Key       | Action          |
|-----------|-----------------|
| `Space`   | Slideshow       |
| `i`       | Toggle info     |
| `d`       | Toggle animation|
| `q`/`Esc` | Quit            |
