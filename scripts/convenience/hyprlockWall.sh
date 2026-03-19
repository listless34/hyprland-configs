#!/usr/bin/env bash

export WALLPAPER=$(swww query | awk '{ print $NF }')
export COLOR_RGB=$(sed -n '15{p;q}' $HOME/.cache/wal/colors-rgb)

hyprlock
