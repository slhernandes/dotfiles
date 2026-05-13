#!/bin/zsh

ROFI_THEME="$XDG_CONFIG_HOME/rofi/themes/no-icon.rasi"
BROWSER="firefox"

result=":"
result+=$(echo "" | rofi -dmenu -l 0 -p "🌐" -theme $ROFI_THEME)

search=$(echo "$result" | cut -d ":" -f 2)
content=$(echo "$result" | cut -d ":" -f 3-)

if [ -z "$content" ]; then
  content=$search
  search=""
fi

# replace colliding special chars with ascii
content=$(echo "$content" | sed "s|%|%25|g")
content=$(echo "$content" | sed "s|#|%23|g")
content=$(echo "$content" | sed "s|\\$|%24|g")
content=$(echo "$content" | sed "s|&|%26|g")
content=$(echo "$content" | sed "s|+|%2B|g")
content=$(echo "$content" | sed "s|,|%2C|g")
content=$(echo "$content" | sed "s|/|%2F|g")
content=$(echo "$content" | sed "s|:|%3A|g")
content=$(echo "$content" | sed "s|;|%3B|g")
content=$(echo "$content" | sed "s|=|%3D|g")
content=$(echo "$content" | sed "s|?|%3F|g")
content=$(echo "$content" | sed "s|@|%40|g")

case $search in
  w)
    content=$(echo "$content" | tr " " "+")
    site=$(printf "https://en.wikipedia.org/w/index.php?search=%s" "$content")
    ;;
  aw)
    content=$(echo "$content" | tr " " "+")
    site=$(printf "https://wiki.archlinux.org/index.php?search=%s" "$content")
    ;;
  gh)
    site=$(printf "https://github.com/search?q=%s&type=repositories" "$content")
    ;;
  yt)
    content=$(echo "$content" | tr " " "+")
    site=$(printf "https://www.youtube.com/results?search_query=%s" "$content")
    ;;
  wa)
    content=$(echo "$content" | tr " " "+")
    site=$(printf "https://www.wolframalpha.com/input?i=%s" "$content")
    echo "$site"
    ;;
  *)
    if [ -n "$search" ]; then
      if [ -n "$XDG_CONFIG_HOME" ]; then
        icons_dir="$XDG_CONFIG_HOME"
      else
        icons_dir="$HOME/.config"
      fi
      icons_dir+="/hypr/icons"
      notify-send -r 80085 -u low -i ${icons_dir}/dialog-warning.svg \
        \"rofisearch\" \"$search is not available. Searching from default search engine\" -h string:synchronous:test
    fi
    content=$(echo "$content" | tr " " "+")
    site=$(printf "https://duckduckgo.com/?t=ftsa&q=%s&ia=web" "$content")
    ;;
esac

if [ -n "$content" ]; then
  $BROWSER --new-tab "$site"
fi
