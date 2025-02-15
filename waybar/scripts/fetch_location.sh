#!/usr/bin/env zsh
LOCATION_FILE="/tmp/weather_loc"
DEFAULT_LOCATIONS=(Auto Berlin Munich Jakarta Singapore Tokyo)
COUNT=${#DEFAULT_LOCATIONS[@]}
if [ $COUNT -ge 8 ]; then
  COUNT=8
fi

LOCATION=$(print -l ${DEFAULT_LOCATIONS} | rofi -dmenu -l $COUNT -p "Choose location: " -i)
if [ -n "$LOCATION" ]; then
  if [ "$LOCATION" = "Auto" ]; then
    LOCATION=""
  fi
  echo $LOCATION > $LOCATION_FILE
fi
