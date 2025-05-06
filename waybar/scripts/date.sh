#!/bin/sh
text=$(date +%a,%d.\ %b\ %Y)
tooltip=$(cal | sed -Ez '$ s/[[:space:]]+\n+*$//' | tr '\n' '|' | sed 's/|/\\n/g')
echo -n "{\"text\": \""
echo -n "$text\", "
echo -n "\"tooltip\": \""
echo -n "<span font_desc=\\\"Noto Sans Mono Regular 12\\\">${tooltip}</span>"
echo -en "\"}"
