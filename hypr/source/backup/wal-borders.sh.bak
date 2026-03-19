#!/bin/bash

WAL_COLORS="$HOME/.cache/wal/colors"

ACTIVE=$(sed -n '15p' "$WAL_COLORS")
INACTIVE=$(sed -n '13p' "$WAL_COLORS")

hyprctl keyword general:col.active_border "rgb(${ACTIVE#\#})"
hyprctl keyword general:col.inactive_border "rgb(${INACTIVE#\#})"
