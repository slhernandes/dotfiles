#!/bin/sh
LC_TEMP=de_DE.utf8
text=$(LC_ALL=$LC_TEMP date +%a,\ %d.%m.%Y)
tooltip=$(LC_ALL=$LC_TEMP cal | sed -Ez '$ s/[[:space:]]+\n+*$//' | tr '\n' '|' | sed 's/|/\\n/g')
echo -n "{\"text\": \""
echo -n "$text\", "
echo -n "\"tooltip\": \""
echo -n "<span font_desc=\\\"Noto Sans Mono Regular 12\\\">${tooltip}</span>"
echo -en "\"}"
