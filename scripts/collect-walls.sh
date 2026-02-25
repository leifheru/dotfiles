#!/usr/bin/env bash
# ─── Collect Wallpapers ───
# Recursively finds all image files in a source folder,
# copies them to a destination folder, and renames them 1, 2, 3...
# preserving the original file extension.
#
# Usage: ./collect-walls.sh [source_dir] [dest_dir]
#   source_dir  — folder to search (default: ~/Pictures)
#   dest_dir    — output folder   (default: ~/Pictures/walls)

set -euo pipefail

SRC="${1:-$HOME/Pictures}"
DEST="${2:-$HOME/Pictures/walls}"

if [[ ! -d "$SRC" ]]; then
    echo "Error: source directory '$SRC' does not exist."
    exit 1
fi

mkdir -p "$DEST"

count=0

# Find common image formats recursively
find "$SRC" -type f \( \
    -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \
    -o -iname '*.webp' -o -iname '*.bmp' -o -iname '*.gif' \
    -o -iname '*.tiff' -o -iname '*.svg' \
\) -not -path "$DEST/*" | sort | while read -r file; do
    count=$((count + 1))
    ext="${file##*.}"
    ext="${ext,,}"  # lowercase
    cp "$file" "$DEST/${count}.${ext}"
    chmod 644 "$DEST/${count}.${ext}"
    echo "[$count] $(basename "$file") → ${count}.${ext}"
done

echo "Done! Wallpapers collected in: $DEST"
