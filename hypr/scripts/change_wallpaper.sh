#!/bin/sh

SCRIPT_DIR=$(realpath $0 | xargs dirname)

if [ -z "$XDG_CONFIG_HOME" ]; then
  HYPR_CONFIG="$HOME/.config/hypr"
else
  HYPR_CONFIG="$XDG_CONFIG_HOME/hypr"
fi

WALL_LIST="city\nspace\nstreet\nwoods\nplains"
NEW_WALL=$(echo -en $WALL_LIST | rofi -dmenu -p "select wallpaper: " --only-match)

if [ -n "$NEW_WALL" ]; then
  CH_WALL=$(grep "$NEW_WALL" $HYPR_CONFIG/.wallpaper)
  if [ -n "$CH_WALL" ]; then
    exit 0
  fi
  echo $NEW_WALL > $HYPR_CONFIG/.wallpaper
  $SCRIPT_DIR/wallpaper.sh
  $SCRIPT_DIR/restart_waybar
  swaync-client -rs
fi
