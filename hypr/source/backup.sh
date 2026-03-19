#!/bin/bash
# Backups only files from the current directory into the backup folder

current_dir="$HOME/.config/hypr"
for file in $(find "$current_dir" -maxdepth 2 -type f | grep -v $(basename "$0")); do
  cp "$file" "$current_dir"/source/backup/$(basename $file).bak
done

exa -l "$current_dir"/source/backup
