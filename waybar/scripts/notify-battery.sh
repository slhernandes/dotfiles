#!/bin/sh

NOTIF_FILE=/tmp/battery_notify

NRG_NOW=$(cat /sys/class/power_supply/BAT0/energy_now)
NRG_FULL=$(cat /sys/class/power_supply/BAT0/energy_full)
NRG_PCT=$(echo "print(int($NRG_NOW/$NRG_FULL*100))" | python)

if [ ! -f $NOTIF_FILE ]; then
  echo 1 > $NOTIF_FILE
fi

NOTIFY=$(cat $NOTIF_FILE)

if [ $NOTIFY -eq 1 ] && [ $NRG_PCT -le 10 ]; then
  dunstify 'BATTERY LOW!' 'Shutting down in a couple minutes.' -i ~/.config/waybar/icons/low-bat.png -r 1234 -u critical -h string:x-canonical-private-synchronous:test
  echo 0 > $NOTIF_FILE
elif [ $NRG_PCT -gt 10 ]; then
  echo 1 > $NOTIF_FILE
fi
