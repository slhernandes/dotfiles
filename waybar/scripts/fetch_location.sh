#!/usr/bin/env zsh
ROFI_THEME="$XDG_CONFIG_HOME/rofi/themes/no-icon.rasi"
THEME_STR="window {location: northeast;anchor: northeast;width: 13%;x-offset: -150;}"
LOCATION_FILE="/tmp/weather_loc"
DEFAULT_LOCATIONS=(Auto Berlin Munich Jakarta Singapore Tokyo)
COUNT=${#DEFAULT_LOCATIONS[@]}
if [ $COUNT -ge 8 ]; then
  COUNT=8
fi

LOCATION=$(print -l ${DEFAULT_LOCATIONS} | rofi -dmenu -l $COUNT -p "Choose location: " -i -theme $ROFI_THEME -theme-str $THEME_STR)
if [ -n "$LOCATION" ]; then
  if [ "$LOCATION" = "Auto" ]; then
    LOCATION=""
  fi
  echo $LOCATION > $LOCATION_FILE
fi
