#!/usr/bin/env bash
EWW_CMD=$(eww -c . get EWW_CMD | tr -d '"')

ping -c 1  "www.google.com" || {
    $EWW_CMD update connected=true
    exit 1
}
$EWW_CMD update connected=false
city=$($EWW_CMD get update_city)
if [ "$city" == "" ]; then
    sh ~/.config/eww/clock/scripts/get_geolocation.sh
fi

