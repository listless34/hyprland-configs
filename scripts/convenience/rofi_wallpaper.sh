#!/usr/bin/env bash

img_dir="$HOME/Pictures/Wallpapers"

selected_image=$(
  find "$img_dir" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) |
    sort |
    while read -r img; do
      name="$(basename "$img")"
      echo -e "$name\0icon\x1f$img"
    done |
    rofi -dmenu \
      -i \
      -p "Wallpapers" \
      -theme "$HOME/.cache/wal/colors-rofi-wallpaper.rasi"
)

# Output full path (or use it to set wallpaper)
[ -n "$selected_image" ] && swww img "$img_dir/$selected_image" --transition-type any --transition-duration 1.0 && ~/.config/scripts/convenience/run_pywal.sh
