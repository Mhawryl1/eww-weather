#!/usr/bin/env bash
EWW_CMD=$(eww -c . get EWW_CMD | tr -d '"')

CITY="$($EWW_CMD get update-city)"
if [ -z "$CITY" ]; then
    ./scripts/get_geolocation.sh
fi
counter=10
while  [ -z "$CITY" ] && [ $counter -gt 0 ] ; do
    sleep 1
    CITY="$($EWW_CMD get update-city)"
    ((counter-- ))
done
if [ -z "$CITY" ] ; then
    CITY="London"
fi
JSON=$(~/.config/eww/clock/bin/fetch -c ${CITY} -u METRIC)
eww $EWW_CMD update JSON="$JSON"
~/.config/eww/clock/scripts/update_city.sh
