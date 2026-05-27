#!/bin/zsh

SCRIPT_DIR=$(echo $0 | xargs realpath | xargs dirname)
QS_ROOT=$(echo $SCRIPT_DIR/.. | xargs realpath)
HYPR_DIR=$XDG_CONFIG_HOME/hypr

picked_theme_qml=$(cat $QS_ROOT/.current_theme)
picked_theme=$(echo $picked_theme_qml | awk -F"." '{print $1}')

wall="$(qs ipc call wallpaper checkTime)_$(cat $HYPR_DIR/.wallpaper)"

if [ "${picked_theme:l}" != "pywal" ]; then
  wal --backend colorz -i "$HYPR_DIR/wallpapers/${wall}.png" -n -t -s -e
else
  wal --backend colorz -i "$HYPR_DIR/wallpapers/${wall}.png" -n -t -e
fi
qs ipc call themeLoader setTheme ${picked_theme_qml}
hyprctl reload
killall -SIGUSR2 ghostty
