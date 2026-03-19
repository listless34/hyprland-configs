#!/usr/bin/env bash

wal -i $(swww query | awk '{ print $NF }') --contrast 5.0 -q
~/.config/hypr/scripts/wal-borders.sh
