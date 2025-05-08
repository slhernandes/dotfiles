#!/usr/bin/env dash

DND_STATUS=$(swaync-client -D)
NOTIF_COUNT=$(swaync-client -c)

if [ "$DND_STATUS" = "true" ]; then
  STATUS="󰽧"
else
  STATUS=""
fi

printf '{"text": "%s", "tooltip": "%s notifications"}' "$STATUS" "$NOTIF_COUNT"
