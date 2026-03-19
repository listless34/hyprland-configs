#!/usr/bin/env bash
set -euo pipefail

THEME="$HOME/.cache/wal/colors-rofi-wifi.rasi"

# Faster than forcing rescan every time
nmcli device wifi list --rescan auto >/dev/null

menu_entries=$(
  nmcli -t -f IN-USE,SSID,SECURITY,SIGNAL dev wifi list |
    awk -F: '
{
    inuse=$1
    ssid=$2
    security=$3
    signal=$4

    if (ssid == "") ssid="(hidden)"

    lock = (security=="--") ? "" : " 🔒"
    active = (inuse=="*") ? "✅ " : ""

    # DISPLAY || REAL SSID
    printf "%s%s%s (%s%%)|%s\n", active, ssid, lock, signal, ssid
}'
)

chosen=$(
  echo "$menu_entries" |
    cut -d'|' -f1 |
    rofi -dmenu \
      -i \
      -p "󰖩 WiFi" \
      -theme "$THEME"
)

[ -z "$chosen" ] && exit 0

ssid=$(echo "$menu_entries" | grep "^$chosen|" | cut -d'|' -f2)

# Hidden network
if [ "$ssid" = "(hidden)" ]; then
  ssid=$(rofi -dmenu -p "Hidden SSID" -theme "$THEME")
fi

# Connect
if nmcli connection show "$ssid" >/dev/null 2>&1; then
  nmcli connection up "$ssid"
else
  password=$(rofi -dmenu -password -p "Password" -theme "$THEME")

  if [ -z "$password" ]; then
    nmcli dev wifi connect "$ssid"
  else
    nmcli dev wifi connect "$ssid" password "$password"
  fi
fi

notify-send "WiFi Connected" "$ssid"
