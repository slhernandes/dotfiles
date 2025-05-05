#!/bin/zsh

if [ -z "$XDG_CONFIG_HOME" ]; then
  waybar_dir="$HOME/.config/waybar"
else
  waybar_dir="$XDG_CONFIG_HOME/waybar"
fi

if [ -z "$XDG_CONFIG_HOME" ]; then
  swaync_dir="$HOME/.config/swaync"
else
  swaync_dir="$XDG_CONFIG_HOME/swaync"
fi

if [ -z "$XDG_CONFIG_HOME" ]; then
  hypr_dir="$HOME/.config/hypr"
else
  hypr_dir="$XDG_CONFIG_HOME/hypr"
fi

if [ -z "$XDG_CACHE_HOME" ]; then
  pywal_css="$HOME/.cache/wal/colors-waybar.css"
else
  pywal_css="$XDG_CACHE_HOME/wal/colors-waybar.css"
fi

if [ ! -d "$waybar_dir" ] || [ -z "$waybar_dir" ] || [ ! -f "$pywal_css" ] || [ -z "$pywal_css" ] || [ ! -d "$waybar_dir" ] || [ -z "$waybar_dir" ]; then
  exit 1
fi

themes=(pywal tokyonight catpuccin_macchiato)
joined_themes=$(echo $themes[@] | tr ' ' '\n')
picked_theme=$(echo $joined_themes | rofi -dmenu -p "choose theme:" --only-match -l ${#themes[@]})

if [ "$picked_theme" = "pywal" ]; then
  ln -sf ${pywal_css} ${waybar_dir}/colors.css
  ln -sf ${pywal_css} ${swaync_dir}/colors.css
elif [ -n "$picked_theme" ]; then
  ln -sf ${waybar_dir}/themes/${picked_theme}/colors.css ${waybar_dir}/colors.css
  ln -sf ${swaync_dir}/themes/${picked_theme}/colors.css ${swaync_dir}/colors.css
else
  exit 1
fi

$hypr_dir/scripts/restart_waybar
swaync-client -rs
