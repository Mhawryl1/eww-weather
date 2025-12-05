#!/usr/bin/env bash

json=$(curl -s --fail http://ip-api.com/json/ 2>/dev/null) || json=""
if [ "$json" == "" ] ; then
    city="London"
else
    city=$(echo "$json" | jq -r .city)
    eww -c ~/.config/eww/clock update update-city="$city"
    eww -c ~/.config/eww/clock update msg-show="false"
fi
echo "$city"
