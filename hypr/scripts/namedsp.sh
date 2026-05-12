#!/bin/sh

SHADER_PATH=$HOME/.config/ghostty/shaders/retro.glsl

case $1 in
  btop)
    workspace_name=$(hyprctl workspaces | grep "special:btop")
    if [ -z "$workspace_name" ]; then
      cmd=$(printf "hl.exec_cmd(\"ghostty --custom-shader=%s -e btop\", { workspace = \"special:btop\", focus_on_activate = true })" "$SHADER_PATH")
      hyprctl dispatch "$cmd"
    else
      hyprctl dispatch 'hl.dsp.workspace.toggle_special("btop")'
    fi
    ;;
  firefox)
    workspace_name=$(hyprctl workspaces | grep "special:firefox")
    if [ -z "$workspace_name" ]; then
      # hyprctl dispatch 'hl.exec_cmd("firefox --name=firefox_sp --new-instance -P scratchpad", { workspace = "special:firefox" })'
      hyprctl dispatch 'hl.exec_cmd("firefox --name=firefox_sp -P scratchpad", { workspace = "special:firefox", focus_on_activate = true })'
    else
      hyprctl dispatch 'hl.dsp.workspace.toggle_special("firefox")'
    fi
    ;;
  wezterm)
    workspace_name=$(hyprctl workspaces | grep "special:wezterm")
    if [ -z "$workspace_name" ]; then
      hyprctl dispatch 'hl.exec_cmd("wezterm start --class=wezterm_sp", { workspace = "special:wezterm", focus_on_activate = true })'
    else
      hyprctl dispatch 'hl.dsp.workspace.toggle_special("wezterm")'
    fi
    ;;
  ghostty)
    workspace_name=$(hyprctl workspaces | grep "special:ghostty")
    if [ -z "$workspace_name" ]; then
      cmd=$(printf "hl.exec_cmd(\"ghostty --custom-shader=%s\", { workspace = \"special:ghostty\", focus_on_activate = true, focus_on_activate = true })" "$SHADER_PATH")
      hyprctl dispatch "$cmd"
    else
      hyprctl dispatch 'hl.dsp.workspace.toggle_special("wezterm")'
    fi
    ;;
  neomutt)
    workspace_name=$(hyprctl workspaces | grep "special:neomutt")
    if [ -z "$workspace_name" ]; then
      cmd=$(printf "hl.exec_cmd(\"ghostty --custom-shader=%s -e neomutt\", { workspace = \"special:neomutt\", focus_on_activate = true })" "$SHADER_PATH")
      hyprctl dispatch "$cmd"
    else
      hyprctl dispatch 'hl.dsp.workspace.toggle_special("neomutt")'
    fi
    ;;
  yazi)
    workspace_name=$(hyprctl workspaces | grep "special:yazi")
    if [ -z "$workspace_name" ]; then
      cmd=$(printf "hl.exec_cmd(\"ghostty --custom-shader=%s -e yazi\", { workspace = \"special:yazi\", focus_on_activate = true })" "$SHADER_PATH")
      hyprctl dispatch "$cmd"
    else
      hyprctl dispatch 'hl.dsp.workspace.toggle_special("yazi")'
    fi
    ;;
  ferdium)
    workspace_name=$(hyprctl workspaces | grep "special:ferdium")
    if [ -z "$workspace_name" ]; then
      hyprctl dispatch 'hl.exec_cmd("ferdium", { workspace = "special:ferdium", focus_on_activate = true })'
    else
      hyprctl dispatch 'hl.dsp.workspace.toggle_special("ferdium")'
    fi
    ;;
  ncmpcpp)
    workspace_name=$(hyprctl workspaces | grep "special:ncmpcpp")
    if [ -z "$workspace_name" ]; then
      cmd=$(printf "hl.exec_cmd(\"ghostty --custom-shader=%s -e ncmpcpp\", { workspace = \"special:ncmpcpp\", focus_on_activate = true })" "$SHADER_PATH")
      hyprctl dispatch "$cmd"
    else
      hyprctl dispatch 'hl.dsp.workspace.toggle_special("ncmpcpp")'
    fi
    ;;
  *)
    >&2 echo "Error: scratchpad name \"$1\" not defined."
    ;;
esac
