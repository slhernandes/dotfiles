#!/bin/sh

case $1 in
  btop)
    workspace_name=$(hyprctl workspaces | grep "special:btop")
    if [ -n "$workspace_name" ]; then
      hyprctl dispatch togglespecialworkspace "btop"
    else
      wezterm start --class=btop_sp -e btop
    fi
    ;;
  firefox)
    workspace_name=$(hyprctl workspaces | grep "special:firefox")
    if [ -n "$workspace_name" ]; then
      hyprctl dispatch togglespecialworkspace "firefox"
    else
      firefox --name firefox_sp -P scratchpad
    fi
    ;;
  wezterm)
    workspace_name=$(hyprctl workspaces | grep "special:wezterm")
    if [ -n "$workspace_name" ]; then
      hyprctl dispatch togglespecialworkspace "wezterm"
    else
      wezterm start --class=wezterm_sp
    fi
    ;;
  neomutt)
    workspace_name=$(hyprctl workspaces | grep "special:neomutt")
    if [ -n "$workspace_name" ]; then
      hyprctl dispatch togglespecialworkspace "neomutt"
    else
      wezterm start --class=neomutt_sp -e neomutt
    fi
    ;;
  ytermusic)
    workspace_name=$(hyprctl workspaces | grep "special:ytermusic")
    if [ -n "$workspace_name" ]; then
      hyprctl dispatch togglespecialworkspace "ytermusic"
    else
      wezterm start --class=ytermusic_sp -e ytermusic
    fi
    ;;
  *)

    >&2 echo "Error: scratchpad name \"$1\" not defined."
    ;;
esac
