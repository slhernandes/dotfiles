#!/usr/bin/bash

icon_path=/usr/share/icons/Pop/64x64/emblems
notify_id=817

function brightness_notification {
  brightness=$(lux -G | tr '%' ' ')

  # old bar
  # bar=$(seq -s "—" 0 $(python -c "print(round($brightness / 5))") | sed 's/[0-9]//g')
  # rest=$(seq -s "＿" 0 $(python -c "print(round((100 - $brightness) / 5))") | sed 's/[0-9]//g')

  #new bar
  bar=$(seq -s "" 0 $(python -c "print(round($brightness / 5))") | sed 's/[0-9]//g')
  rest=$(seq -s "" 0 $(python -c "print(round((100 - $brightness) / 5))") | sed 's/[0-9]//g')

  start_cnt=$(echo $bar | wc -c)
  if [ -n "$start_cnt" ] && [ "$start_cnt" -gt 1 ]; then
    start=""
    bar=$(echo $bar | cut -b 4-)
  else
    start=""
    rest=$(echo $rest | cut -b 4-)
  fi

  end_cnt=$(echo $rest | wc -c)
  if [ -n "$end_cnt" ] && [ "$end_cnt" -gt 1 ]; then
    fin=""
    rest=$(echo $rest | cut -b 4-)
  else
    fin=""
    bar=$(echo $bar | cut -b 4-)
  fi

  # send notif
  notify-send -r $notify_id -u low -i $icon_path/emblem-system.svg -h int:value:$(($brightness)) "Brightness $(echo "$brightness" | xargs)%" "$start$bar$rest$fin" -h string:synchronous:test -h boolean:SWAYNC_BYPASS_DND:true
}

case $1 in
  up)
    lux -a 5%
    qs ipc call brightnessOSD openOSD $(lux -G)
    # brightness_notification
    ;;
  down)
    lux -s 5%
    qs ipc call brightnessOSD openOSD $(lux -G)
    # brightness_notification
    ;;
  *)
    echo "Usage: $0 up | down "
    ;;
esac
