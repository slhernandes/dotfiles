#!/bin/sh

case $1 in
  btop)
    workspace_name=$(hyprctl workspaces | grep "special:btop")
    if [ -n "$workspace_name" ]; then
      hyprctl dispatch togglespecialworkspace "btop"
    else
      hyprctl dispatch exec '[workspace special:btop]' 'wezterm start --class=btop_sp -e btop'
    fi
    ;;
  firefox)
    workspace_name=$(hyprctl workspaces | grep "special:firefox")
    if [ -n "$workspace_name" ]; then
      hyprctl dispatch togglespecialworkspace "firefox"
    else
      hyprctl dispatch exec '[workspace special:firefox]' 'firefox --name=firefox_sp --new-instance -P scratchpad'
    fi
    ;;
  wezterm)
    workspace_name=$(hyprctl workspaces | grep "special:wezterm")
    if [ -n "$workspace_name" ]; then
      hyprctl dispatch togglespecialworkspace "wezterm"
    else
      hyprctl dispatch exec '[workspace special:wezterm]' 'wezterm start --class=wezterm_sp'
    fi
    ;;
  neomutt)
    workspace_name=$(hyprctl workspaces | grep "special:neomutt")
    if [ -n "$workspace_name" ]; then
      hyprctl dispatch togglespecialworkspace "neomutt"
    else
      hyprctl dispatch exec '[workspace special:neomutt]' 'wezterm start --class=neomutt_sp -e neomutt'
    fi
    ;;
  ytermusic)
    workspace_name=$(hyprctl workspaces | grep "special:ytermusic")
    if [ -n "$workspace_name" ]; then
      hyprctl dispatch togglespecialworkspace "ytermusic"
    else
      hyprctl dispatch exec '[workspace special:ytermusic]' 'wezterm start --class=ytermusic_sp -e ytermusic'
    fi
    ;;
  yazi)
    workspace_name=$(hyprctl workspaces | grep "special:yazi")
    if [ -n "$workspace_name" ]; then
      hyprctl dispatch togglespecialworkspace "yazi"
    else
      hyprctl dispatch exec '[workspace special:yazi]' 'wezterm start --class=yazi_sp -e yazi'
    fi
    ;;
  ferdium)
    workspace_name=$(hyprctl workspaces | grep "special:ferdium")
    if [ -n "$workspace_name" ]; then
      hyprctl dispatch togglespecialworkspace "ferdium"
    else
      hyprctl dispatch exec '[workspace special:ferdium]' 'ferdium'
    fi
    ;;
  termusic)
    workspace_name=$(hyprctl workspaces | grep "special:music")
    if [ -n "$workspace_name" ]; then
      hyprctl dispatch togglespecialworkspace "music"
    else
      hyprctl dispatch exec '[workspace special:music]' 'wezterm start --class=music_sp -e termusic'
    fi
    ;;
  *)

    >&2 echo "Error: scratchpad name \"$1\" not defined."
    ;;
esac
