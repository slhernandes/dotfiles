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
  QS_CONFIG="$HOME/.config/quickshell"
else
  HYPR_CONFIG="$XDG_CONFIG_HOME/hypr"
  QS_CONFIG="$XDG_CONFIG_HOME/quickshell"
fi

WALL_DIR="$HYPR_CONFIG/wallpapers"

echo hypr_config: $HYPR_CONFIG >> $LOG_FILE
echo wall_dir: $WALL_DIR >> $LOG_FILE

SUNRISE="0600"
SUNSET="1800"

LOC=$(timeout 0.2s curl ipinfo.io/$(dig +short google.com) \
  | jq -r ".loc" | awk -F',' '{print $1"N",$2"E"}')
if [ "$?" -eq 0 ]; then
  TMP=$(sunwait list $LOC)
fi
echo LOC: $LOC >> $LOG_FILE
echo TMP: $TMP >> $LOG_FILE

if [ "$?" -eq 0 ]; then
  SUNRISE=$(echo $TMP | awk -F',' '{print $1}' | xargs)
  SUNSET=$(echo $TMP | awk -F',' '{print $2}' | xargs)
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

# remove previous scheduled process(es)
atq -q w | awk '{print $1}' | xargs atrm

if [ $NOW_EPOCH -ge $SUNRISE_EPOCH ] && [ $NOW_EPOCH -lt $SUNSET_EPOCH ]; then
  WALL_TYPE="day"
  echo "$(realpath $0)" | at $SUNSET -q w
elif [ $NOW_EPOCH -ge $SUNSET_EPOCH ]; then
  echo "$(realpath $0)" | at 0001 -q w
else
  echo "$(realpath $0)" | at $SUNRISE -q w
fi

echo wall_type: $WALL_TYPE >> $LOG_FILE

WALL="${WALL_DIR}/${WALL_TYPE}_${WALL_NAME}.png"

echo wall_name: $WALL_NAME >> $LOG_FILE
echo now_epoch: $NOW_EPOCH >> $LOG_FILE
echo sunrise_epoch: $SUNRISE_EPOCH >> $LOG_FILE
echo sunset_epoch: $SUNSET_EPOCH >> $LOG_FILE
echo wall: $WALL >> $LOG_FILE

hyprctl hyprpaper reload ,$WALL
ctr=1
while [ "$(hyprctl hyprpaper listactive)" = "no wallpapers active" ] && [ $ctr -lt 100 ]; do
  hyprctl hyprpaper reload ,$WALL
  ctr=$(expr $ctr + 1)
  echo ctr: $ctr >> $LOG_FILE
  sleep 0.1
done

wal -i $WALL -s -t
swaync-client -rs
if [ -f "${QS_CONFIG}/.current_theme" ]; then
  QS_THEME=$(cat "${QS_CONFIG}/.current_theme" | xargs)
  if [ -n "${QS_THEME}" ]; then
    qs ipc call themeLoader setTheme themes/${QS_THEME}
  fi
fi
