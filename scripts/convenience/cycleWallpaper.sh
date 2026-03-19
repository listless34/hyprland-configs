#!/usr/bin/env bash

set -euo pipefail

dir="$HOME/Pictures/Wallpapers"
wallpapers=($(find "$dir" -maxdepth 1 -type f))
current_wallpaper=$(swww query | awk '{ print $NF }')

if [ ${#wallpapers[@]} -eq 0 ]; then
  echo "No images in this directory"
  exit 1
fi

for pid in $(pgrep -f "$(basename "$0")"); do
  if [ "$pid" != "$$" ]; then
    kill "$pid"
    $HOME/.config/scripts/convenience/run_pywal.sh
    exit 1
  fi
done

index=0

while [[ index -le "${#wallpapers[@]}" ]]; do
  if [ "${wallpapers[$index]}" == "$current_wallpaper" ]; then
    let index++
    break
  fi
  let index++
done

while [[ "$index" -le "${#wallpapers[@]}" ]]; do
  if [ "${wallpapers[$index]}" == "$current_wallpaper" ]; then
    let index++
    break
  fi
  if [ "$(($index + 1))" -eq "${#wallpapers[@]}" ]; then
    index=0
  fi
  swww img "${wallpapers[$index]}" --transition-type any --transition-duration 1
  sleep 2
  let index++
done

#for img in ${wallpapers[@]}; do
#  swww img "$img" --transition-type any --transition-duration 1
#  sleep 2
#done
