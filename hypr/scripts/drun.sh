#!/usr/bin/dash

EMPTY_WIN=$(hyprctl activewindow | grep -i "invalid")

if [ -n "$EMPTY_WIN" ]; then
  THEME_STR="window { y-offset: -36px; }"
  rofi -show drun -theme-str "$THEME_STR"
else
  rofi -show drun
fi
