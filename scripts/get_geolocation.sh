#!/usr/bin/env bash
EWW_CMD=$(eww -c . get EWW_CMD | tr -d '"')

json=$(curl -s --fail http://ip-api.com/json/ 2>/dev/null) || json=""
if [ "$json" == "" ] ; then
    city="London"
else
    city=$(echo "$json" | jq -r .city)
    $EWW_CMD update update-city="$city"
    $EWW_CMD update msg-show="false"
fi
echo "$city"
