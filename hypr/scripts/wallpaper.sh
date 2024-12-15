#!/bin/sh

if [ $(pgrep wallpaper.sh | wc -l) -gt 2 ]; then
  echo "ERROR: wallpaper.sh is already running." > /dev/stderr
  exit 1
fi

SCRIPT_DIR=$(realpath $0 | xargs dirname)
echo $SCRIPT_DIR

if [ -z "$(pgrep hyprpaper)" ]; then
  nohup hyprpaper &
  sleep 0.1
fi

SUNRISE="06:00:00"
SUNSET="18:00:00"
MIDNIGHT=$(date -d 0 +%s)
# Use hard-coded path for wallpapers
# WP_DARK="$SCRIPT_DIR/../wallpapers/sequoia_bg.jpg"
# WP_LIGHT="$SCRIPT_DIR/../wallpapers/custom_bg.png"
# Use first(dark) and second(light) entry of hyprpaper (preload first in hyprpaper.conf)
WP_DARK=$(hyprctl hyprpaper listloaded | sed -n "1p")
WP_LIGHT=$(hyprctl hyprpaper listloaded | sed -n "2p")

TMP=$(timeout 1s curl wttr.in/\?format='%S')
if [ "$?" -eq 0 ]; then
  SUNRISE=$TMP
fi

TMP=$(timeout 1s curl wttr.in/\?format='%s')
if [ "$?" -eq 0 ]; then
  SUNSET=$TMP
fi
SUNRISE=$(date -d $SUNRISE +%s)
SUNSET=$(date -d $SUNSET +%s)

while true; do
  NOW=$(date +%s)
  DIFF=$(python -c "print(int($NOW) - int($MIDNIGHT))")

  if [ $DIFF -le 600 ]; then
    TMP=$(timeout 1s curl wttr.in/\?format='%S')
    if [ "$?" -eq 0 ]; then
      SUNRISE=$TMP
    fi

    TMP=$(timeout 1s curl wttr.in/\?format='%s')
    if [ "$?" -eq 0 ]; then
      SUNSET=$TMP
    fi
    SUNRISE=$(date -d $SUNRISE +%s)
    SUNSET=$(date -d $SUNSET +%s)
  fi

  CHECK_DARK=$(hyprctl hyprpaper listactive | awk '{print $NF}' | grep $WP_DARK)
  CHECK_LIGHT=$(hyprctl hyprpaper listactive | awk '{print $NF}' | grep $WP_LIGHT)

  if [ $NOW -le $SUNRISE ]; then
    if [ -z "$CHECK_DARK" ]; then
      hyprctl hyprpaper wallpaper "eDP-1,$WP_DARK"
    fi
  elif [ $NOW -le $SUNSET ]; then
    if [ -z "$CHECK_LIGHT" ]; then
      hyprctl hyprpaper wallpaper "eDP-1,$WP_LIGHT"
    fi
  else
    if [ -z "$CHECK_DARK" ]; then
      hyprctl hyprpaper wallpaper "eDP-1,$WP_DARK"
    fi
  fi
  sleep 60
done
