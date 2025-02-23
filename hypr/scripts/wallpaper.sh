#!/bin/sh

DEBUG_MODE=2
if [ $DEBUG_MODE -eq 0 ]; then
  LOG_FILE="/dev/null"
elif [ $DEBUG_MODE -eq 1 ]; then
  LOG_FILE="/dev/stdout"
else
  LOG_FILE="/tmp/wallpaper.log"
fi

echo "" > $LOG_FILE

SCRIPT_DIR=$(realpath $0 | xargs dirname)
echo script_dir: $SCRIPT_DIR >> $LOG_FILE

if [ -z "$XDG_CONFIG_HOME" ]; then
  HYPR_CONFIG="$HOME/.config/hypr"
else
  HYPR_CONFIG="$XDG_CONFIG_HOME/hypr"
fi

WALL_DIR="$HYPR_CONFIG/wallpapers"

echo hypr_config: $HYPR_CONFIG >> $LOG_FILE
echo wall_dir: $WALL_DIR >> $LOG_FILE

SUNRISE="0600"
SUNSET="1800"

TMP=$(timeout 1s curl wttr.in/\?format='%S')
if [ "$?" -eq 0 ]; then
  SUNRISE=$(echo $TMP | awk -F":" '{print $1$2}')
else
  DEFAULT_TIME=1
fi

TMP=$(timeout 1s curl wttr.in/\?format='%s')
if [ "$?" -eq 0 ]; then
  SUNSET=$(echo $TMP | awk -F":" '{print $1$2}')
else
  DEFAULT_TIME=1
fi

echo sunrise: $SUNRISE >> $LOG_FILE
echo sunset: $SUNSET >> $LOG_FILE

if [ -f "$HYPR_CONFIG/.wallpaper" ]; then
  WALL_NAME=$(cat "$HYPR_CONFIG/.wallpaper")
else
  WALL_NAME="woods"
fi

NOW_EPOCH=$(date +%s)
SUNRISE_EPOCH=$(date -d $SUNRISE +%s)
SUNSET_EPOCH=$(date -d $SUNSET +%s)
WALL_TYPE="night"

echo wall_name: $WALL_NAME >> $LOG_FILE
echo now_epoch: $NOW_EPOCH >> $LOG_FILE
echo sunrise_epoch: $SUNRISE_EPOCH >> $LOG_FILE
echo sunset_epoch: $SUNSET_EPOCH >> $LOG_FILE
echo is_dark: $IS_DARK >> $LOG_FILE

if [ $NOW_EPOCH -ge $SUNRISE_EPOCH ] && [ $NOW_EPOCH -lt $SUNSET_EPOCH ]; then
  WALL_TYPE="day"
  if [ -z "$(atq -q w)" ]; then
    echo "$(realpath $0)" | at $SUNSET -q w
  fi
else
  if [ -z "$(atq -q w)" ]; then
    echo "$(realpath $0)" | at $SUNRISE -q w
  fi
fi

WALL="${WALL_DIR}/${WALL_TYPE}_${WALL_NAME}.png"

echo wall: $WALL >> $LOG_FILE

hyprctl hyprpaper reload ,$WALL
hyprctl hyprpaper reload eDP-1,$WALL
wal -i $WALL -s -t
