#!/bin/bash

dir="$HOME/Pictures/Wallpapers"
wallpapers=($(find "$dir" -maxdepth 1 -type f))

if [ ${#wallpapers[@]} -eq 0 ]; then
  echo "No images in this directory"
  exit 1
fi

current_img=$(swww query | awk '{ print $NF }')

for index in ${!wallpapers[@]}; do
  if [ "${wallpapers[$index]}" == "$current_img" ]; then
    swww img "${wallpapers[($index + 1) % ${#wallpapers[@]}]}" --transition-type random
    ~/.config/scripts/convenience/run_pywal.sh
    break
  fi
done
