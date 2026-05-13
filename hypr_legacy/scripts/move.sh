#!/bin/sh

ws_id=$(hyprctl activeworkspace | grep "workspace ID" | awk '{print $3}')
py_cmd_next="print(${ws_id}%9+1)"
py_cmd_prev="print((${ws_id}-2)%9+1)"
next_ws=$(python -c ${py_cmd_next})
prev_ws=$(python -c ${py_cmd_prev})

case $1 in
  next)
    hyprctl dispatch movetoworkspace $next_ws
    ;;
  prev)
    hyprctl dispatch movetoworkspace $prev_ws
    ;;
  *)
    echo "Command not found"
    ;;
esac
