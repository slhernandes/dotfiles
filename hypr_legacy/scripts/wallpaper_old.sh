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

if [ $(pgrep wallpaper.sh | wc -l) -gt 2 ]; then
  echo "ERROR: wallpaper.sh is already running." > /dev/stderr
  exit 1
fi

SCRIPT_DIR=$(realpath $0 | xargs dirname)
echo $SCRIPT_DIR >> $LOG_FILE

if [ -z "$(pgrep hyprpaper)" ]; then
  nohup hyprpaper &
  sleep 0.1
fi

SUNRISE="06:00:00"
SUNSET="18:00:00"
MIDNIGHT=$(date -d 0 +%s)

TMP=$(timeout 1s curl wttr.in/\?format='%S')
if [ "$?" -eq 0 ]; then
  SUNRISE=$TMP
else
  DEFAULT_TIME=1
fi

TMP=$(timeout 1s curl wttr.in/\?format='%s')
if [ "$?" -eq 0 ]; then
  SUNSET=$TMP
else
  DEFAULT_TIME=1
fi
echo $SUNRISE >> $LOG_FILE
echo $SUNSET >> $LOG_FILE
SUNRISE=$(date -d $SUNRISE +%s)
SUNSET=$(date -d $SUNSET +%s)

# Use hard-coded path for wallpapers
# WP_DARK="$SCRIPT_DIR/../wallpapers/sequoia_bg.jpg"
# WP_LIGHT="$SCRIPT_DIR/../wallpapers/custom_bg.png"
# Use first(dark) and second(light) entry of hyprpaper (preload first in hyprpaper.conf)
while true; do
  WP_DARK=$(hyprctl hyprpaper listloaded | sed -n "1p")
  if [ -z "$WP_DARK" ]; then
    sleep 1
  else
    break
  fi
done

while true; do
  WP_LIGHT=$(hyprctl hyprpaper listloaded | sed -n "2p")
  if [ -z "$WP_LIGHT" ]; then
    sleep 1
  else
    break
  fi
done

while true; do
  NOW=$(date +%s)
  DIFF=$(python -c "print(int($NOW) - int($MIDNIGHT))")

  if [ $DIFF -le 600 ] || [ $DEFAULT_TIME -eq 1 ]; then
    TMP=$(timeout 1s curl wttr.in/\?format='%S')
    if [ "$?" -eq 0 ]; then
      SUNRISE=$TMP
    else
      sleep 5
      continue
    fi

    TMP=$(timeout 1s curl wttr.in/\?format='%s')
    if [ "$?" -eq 0 ]; then
      SUNSET=$TMP
    else
      sleep 5
      continue
    fi
    SUNRISE=$(date -d $SUNRISE +%s)
    SUNSET=$(date -d $SUNSET +%s)
    echo "sunrise: $SUNRISE" >> $LOG_FILE
    echo "sunset: $SUNSET" >> $LOG_FILE
    DEFAULT_TIME=0
  fi

  echo "active: $(hyprctl hyprpaper listactive | awk '{print $NF}')"
  CHECK_DARK=$(hyprctl hyprpaper listactive | awk '{print $NF}' | grep $WP_DARK)
  CHECK_LIGHT=$(hyprctl hyprpaper listactive | awk '{print $NF}' | grep $WP_LIGHT)

  echo "dark_wp: $CHECK_DARK" >> $LOG_FILE
  echo "light_wp: $CHECK_LIGHT" >> $LOG_FILE
  echo "now: $NOW" >> $LOG_FILE
  echo "sunrise: $SUNRISE" >> $LOG_FILE
  echo "sunset: $SUNSET" >> $LOG_FILE

  if [ $NOW -le $SUNRISE ]; then
    if [ -z "$CHECK_DARK" ]; then
      hyprctl hyprpaper wallpaper "eDP-1,$WP_DARK"
      wal -i $WP_DARK -s -t
    fi
  elif [ $NOW -le $SUNSET ]; then
    if [ -z "$CHECK_LIGHT" ]; then
      hyprctl hyprpaper wallpaper "eDP-1,$WP_LIGHT"
      wal -i $WP_DARK -s -t
    fi
  else
    if [ -z "$CHECK_DARK" ]; then
      hyprctl hyprpaper wallpaper "eDP-1,$WP_DARK"
      wal -i $WP_DARK -s -t
    fi
  fi
  sleep 60
done
