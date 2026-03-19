#!/usr/bin/env bash

# exit immediately if activation or the script fails
set -e

CURRENT_DIR="$HOME/.config/scripts/convenience/python_scripts"

source "$CURRENT_DIR/wallpaper/bin/activate"
"$CURRENT_DIR/wallpaper/bin/python" "$CURRENT_DIR/wallpaper_download.py"
deactivate
