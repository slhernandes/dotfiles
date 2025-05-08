#!/usr/bin/env dash

ROFI_THEME=$XDG_CONFIG_HOME/rofi/themes/power-menu.rasi
mode=$(printf "nerd_font\nemoji\n" | rofi -dmenu -l 2 -theme $ROFI_THEME -theme-str "window{width: 13%;}")
rofimoji -f $mode
