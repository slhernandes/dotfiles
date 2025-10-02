#!/bin/dash
SCRIPT_DIR=$(realpath $0 | xargs dirname)
API_KEY=$(cat $SCRIPT_DIR/../api_keys.json | jq -r '.OPENWEATHER_API_KEY')
CITY=$(cat $SCRIPT_DIR/weatherParameter.json | jq -r ".city")
LANGUAGE=$(cat $SCRIPT_DIR/weatherParameter.json | jq -r ".lang")
echo $CITY
echo $LANGUAGE
URL_GEO="https://api.openweathermap.org/data/2.5/weather?q=${CITY}&appid=${API_KEY}&lang=${LANGUAGE}"
curl $URL_GEO > $SCRIPT_DIR/../weather.json
