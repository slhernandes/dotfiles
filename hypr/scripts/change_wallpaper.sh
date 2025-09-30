#!/bin/zsh

ROFI_THEME=$XDG_CONFIG_HOME/rofi/themes/no-icon.rasi

SCRIPT_DIR=$(realpath $0 | xargs dirname)

if [ -z "$XDG_CONFIG_HOME" ]; then
  HYPR_CONFIG="$HOME/.config/hypr"
else
  HYPR_CONFIG="$XDG_CONFIG_HOME/hypr"
fi

EMPTY_WIN=$(hyprctl activewindow | grep -i "invalid")

if [ -n "$EMPTY_WIN" ]; then
  OFFSET="y-offset: -36px;"
fi

WALL_LIST=(city space street woods plains)
JOINED_WALL_LIST=$(echo $WALL_LIST[@] | tr ' ' '\n')
NEW_WALL=$(echo -en $JOINED_WALL_LIST | rofi -dmenu -p "🖼️ " --only-match -l ${#WALL_LIST[@]} -theme $ROFI_THEME -theme-str "window {width: 13%;$OFFSET}")

if [ -n "$NEW_WALL" ]; then
  CH_WALL=$(grep "$NEW_WALL" $HYPR_CONFIG/.wallpaper)
  # if [ -n "$CH_WALL" ]; then
  #   exit 0
  # fi
  echo $NEW_WALL > $HYPR_CONFIG/.wallpaper
  $SCRIPT_DIR/wallpaper.sh -f
  # $SCRIPT_DIR/restart_waybar
  swaync-client -rs
fi
