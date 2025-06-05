#!/bin/sh

SHADER_PATH=$HOME/.config/ghostty/shaders/retro.glsl

case $1 in
  btop)
    workspace_name=$(hyprctl workspaces | grep "special:btop")
    if [ -n "$workspace_name" ]; then
      hyprctl dispatch togglespecialworkspace "btop"
    else
      hyprctl dispatch exec '[workspace special:btop]' "ghostty --custom-shader=$SHADER_PATH -e btop"
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
  ghostty)
    workspace_name=$(hyprctl workspaces | grep "special:ghostty")
    if [ -n "$workspace_name" ]; then
      hyprctl dispatch togglespecialworkspace "ghostty"
    else
      hyprctl dispatch exec '[workspace special:ghostty]' "ghostty --custom-shader=$SHADER_PATH"
    fi
    ;;
  neomutt)
    workspace_name=$(hyprctl workspaces | grep "special:neomutt")
    if [ -n "$workspace_name" ]; then
      hyprctl dispatch togglespecialworkspace "neomutt"
    else
      hyprctl dispatch exec '[workspace special:neomutt]' "ghostty --custom-shader=$SHADER_PATH -e neomutt"
    fi
    ;;
  ytermusic)
    workspace_name=$(hyprctl workspaces | grep "special:ytermusic")
    if [ -n "$workspace_name" ]; then
      hyprctl dispatch togglespecialworkspace "ytermusic"
    else
      hyprctl dispatch exec '[workspace special:ytermusic]' "ghostty --custom-shader=$SHADER_PATH -e ytermusic"
    fi
    ;;
  yazi)
    workspace_name=$(hyprctl workspaces | grep "special:yazi")
    if [ -n "$workspace_name" ]; then
      hyprctl dispatch togglespecialworkspace "yazi"
    else
      hyprctl dispatch exec '[workspace special:yazi]' "ghostty --custom-shader=$SHADER_PATH -e yazi"
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
    workspace_name=$(hyprctl workspaces | grep "special:termusic")
    if [ -n "$workspace_name" ]; then
      hyprctl dispatch togglespecialworkspace "termusic"
    else
      hyprctl dispatch exec '[workspace special:termusic]' "ghostty --custom-shader=$SHADER_PATH -e termusic"
    fi
    ;;
  ncmpcpp)
    workspace_name=$(hyprctl workspaces | grep "special:ncmpcpp")
    if [ -n "$workspace_name" ]; then
      hyprctl dispatch togglespecialworkspace "ncmpcpp"
    else
      hyprctl dispatch exec '[workspace special:ncmpcpp]' "ghostty --custom-shader=$SHADER_PATH -e ncmpcpp"
    fi
    ;;
  *)

    >&2 echo "Error: scratchpad name \"$1\" not defined."
    ;;
esac
