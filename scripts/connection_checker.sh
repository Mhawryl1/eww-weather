#!/usr/bin/env bash
EWW_CMD=$(eww -c . get EWW_CMD | tr -d '"')
prevState=$($EWW_CMD get connected)
ping -c 1  "www.google.com" || {
    $EWW_CMD update connected=true
    exit 1
}
$EWW_CMD update connected=false
if [ $prevState == true ] ; then
    ./scripts/get_geolocation.sh
    ./scripts/update_city.sh
fi

