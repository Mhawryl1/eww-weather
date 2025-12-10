#!/usr/bin/bash

CITY="$(/usr/bin/eww -c ~/.config/eww/clock get update-city)"
counter=10
while  [ "$CITY" == "" ] && [ $counter -gt 0 ] ; do
    sleep 1
    CITY="$(/usr/bin/eww -c ~/.config/eww/clock get update-city)"
    ((counter-- ))
done
if [ "$CITY" == "" ] ; then
    CITY="London"
fi
~/.config/eww/clock/bin/weather -c ${CITY} -u METRIC
