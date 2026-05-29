#!/bin/zsh

ROFI_THEME=$XDG_CONFIG_HOME/rofi/themes/power-menu.rasi

if [ -z "$XDG_CONFIG_HOME" ]; then
  swaync_dir="$HOME/.config/swaync"
else
  swaync_dir="$XDG_CONFIG_HOME/swaync"
fi

if [ -z "$XDG_CONFIG_HOME" ]; then
  hypr_dir="$HOME/.config/hypr"
else
  hypr_dir="$XDG_CONFIG_HOME/hypr"
fi

if [ -z "$XDG_CONFIG_HOME" ]; then
  qs_dir="$HOME/.config/quickshell"
else
  qs_dir="$XDG_CONFIG_HOME/quickshell"
fi

ghostty_dir="$HOME/dotfiles/ghostty"

if [ ! -d "$swaync_dir" ] || [ -z "$swaync_dir" ]; then
  exit 1
fi

if [ ! -d "$hypr_dir" ] || [ -z "$hypr_dir" ]; then
  exit 1
fi

if [ ! -d "$qs_dir" ] || [ -z "$qs_dir" ]; then
  exit 1
fi

EMPTY_WIN=$(hyprctl activewindow | grep -i "invalid")

if [ -n "$EMPTY_WIN" ]; then
  OFFSET="y-offset: -36px;"
fi

pref=$(qs ipc call wallpaper checkTime)
wall=$(cat $XDG_CONFIG_HOME/hypr/.wallpaper)
echo ${pref}_${wall}
wal --backend colorz -i "$XDG_CONFIG_HOME/hypr/wallpapers/${pref}_${wall}.png" -n -q -s -t -e
themes=$(ls ${qs_dir}/themes | cut -d "." -f 1)
picked_theme=$(echo ${themes} | rofi -dmenu --only-match -l $(echo ${themes} | wc -l) -theme ${ROFI_THEME} -theme-str "window {width: 13%;${OFFSET}}")

if [ -n "$picked_theme" ]; then
  # ln -sf ${swaync_dir}/themes/${picked_theme}/colors.css ${swaync_dir}/colors.css
  qs ipc call themeLoader setTheme ${picked_theme}.qml
  echo ${picked_theme:l} > $hypr_dir/.theme
  hyprctl eval "local helper = require(\"configs.helper\"); helper.changeTheme(\"${picked_theme:l}\")"
  sed -i.bak "s|\(theme = \)\"\(.*\)\"|\\1\"${picked_theme}\"|" $ghostty_dir/config
  killall -SIGUSR2 ghostty
  echo "${picked_theme}.qml" > ${qs_dir}/.current_theme
else
  exit 1
fi
