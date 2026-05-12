#!/bin/sh

ws_name=$(hyprctl activewindow -j | jq '.workspace.name' | tr '"' ' ' | xargs)
is_special=$(echo $ws_name | grep -E 'special:.*')

if [ -z "$is_special" ]; then
  ws_name="magic"
else
  ws_name=$(echo $ws_name | awk -F':' '{print $2}')
fi

echo $ws_name
dispatch=$(printf "hl.dsp.workspace.toggle_special(\"%s\")" $ws_name)
hyprctl dispatch $dispatch
