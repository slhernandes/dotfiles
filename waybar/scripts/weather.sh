#!/bin/sh

SCRIPT_DIR=$(echo $0 | xargs realpath | xargs dirname)

DEBUG=0
if [ $DEBUG -eq 1 ]; then
  LOG_FILE="/tmp/weather.log"
else
  LOG_FILE="/dev/null"
fi
echo "STARTING DEBUG MODE" > $LOG_FILE

echo "Before sleep:" >> $LOG_FILE
sleep .1
PID=$(pgrep zsh -a | grep fetch_location | head -n 1 | awk '{print $1}')
while [ -n "$PID" ] && [ -e "/proc/$PID" ]; do
  sleep .1
done
echo "After sleep:" >> $LOG_FILE

LOCATION_FILE="/tmp/weather_loc"
if [ -f "$LOCATION_FILE" ]; then
  LOCATION=$(cat /tmp/weather_loc)
fi

WEATHER_TMP=$(timeout 5s curl wttr.in/$LOCATION\?format="%t+%w|%c\n")
EXIT_STATUS=$?

if [ -n "$LOCATION" ]; then
  TOOLTIP=$LOCATION
else
  TOOLTIP="Current Location"
fi

if [ $EXIT_STATUS -ne 0 ] || [ -n "$(echo $WEATHER_TMP | grep "Unknown")" ]; then
  WEATHER="$(head -n 1 $SCRIPT_DIR/weather_cache)"
  TOOLTIP="$(tail -n 1 $SCRIPT_DIR/weather_cache) (cached)"
else
  WEATHER=$(echo $WEATHER_TMP | awk -F"|" '{print $1}')
  TOOLTIP="$(echo $WEATHER_TMP | awk -F"|" '{print $2}') $TOOLTIP"
  echo $WEATHER >  $SCRIPT_DIR/weather_cache
  echo $TOOLTIP >> $SCRIPT_DIR/weather_cache
fi

echo "{\"text\":\"$WEATHER\",\"tooltip\":\"$TOOLTIP\"}"

echo "weather: $WEATHER, location: $TOOLTIP" >> $LOG_FILE
