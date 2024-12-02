#!/usr/bin/env zsh
LOCATION_FILE="/tmp/weather_loc"
DEFAULT_LOCATIONS=(Auto Berlin Munich Jakarta Singapore Tokyo)
LOCATION=$(print -l ${DEFAULT_LOCATIONS} | rofi -dmenu -p "Choose location: " -i)
if [ -n "$LOCATION" ]; then
  if [ "$LOCATION" = "Auto" ]; then
    LOCATION=""
  fi
  echo $LOCATION > $LOCATION_FILE
fi
