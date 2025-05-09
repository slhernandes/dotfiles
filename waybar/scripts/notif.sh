#!/usr/bin/env dash

DND_STATUS=$(swaync-client -D)
NOTIF_COUNT=$(swaync-client -c)

if [ "$DND_STATUS" = "true" ]; then
  STATUS="󰽧"
  CLASS="on"
else
  STATUS=""
  CLASS="off"
fi

printf '{"text": "%s", "tooltip": "%s notifications", "class": "%s"}' "$STATUS" "$NOTIF_COUNT" "$CLASS"
