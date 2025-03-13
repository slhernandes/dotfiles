#!/usr/bin/bash

icon_path=/usr/share/icons/Pop/64x64/emblems
notify_id=817

function brightness_notification {
  brightness=`lux -G | tr '%' ' '`
  notify-send -r $notify_id -u low -i $icon_path/emblem-system.svg -h int:value:$(($brightness)) "Brightness" "" -h string:synchronous:test -h boolean:SWAYNC_BYPASS_DND:true
}

case $1 in
  up)
    lux -a 5%
    brightness_notification
    ;;
  down)
    lux -s 5%
    brightness_notification
    ;;
  *)
    echo "Usage: $0 up | down "
    ;;
esac
