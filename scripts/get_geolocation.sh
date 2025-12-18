#!/usr/bin/env bash
EWW_CMD=$(eww -c . get EWW_CMD | tr -d '"')

CITY=$(${EWW_CMD} get update-city )

if [[ -z $CITY ]] ; then
    CITY=$(cat .save_city.txt 2>/dev/null || echo "" | tr -d '\n' )
    PREVLOCATION=$(cat .prev_geolocation.txt 2>/dev/null || echo "" | tr -d '\n' )
    CURENTLOCATION=$($EWW_CMD get location)
    counter=0
    while [[ -z $CURENTLOCATION || $counter -lt 10 ]]; do
        sleep 0.5
        CURENTLOCATION=$($EWW_CMD get location)
        if [[ $CURENTLOCATION != "" ]]; then
            break
        fi
        counter=$((counter+1))
    done

    if [[ "$PREVLOCATION" != "$CURENTLOCATION" ]]; then
        echo $CURENTLOCATION > .prev_geolocation.txt
        $EWW_CMD update update-city="$CURENTLOCATION"
        $EWW_CMD update msg-show="false"
        rm -f .save_city.txt
        exit 0
    fi
    if [[ -z $CITY && -z $CURENTLOCATION ]] ; then
        CITY="London"
    elif [[ -z $CITY ]]; then
        $EWW_CMD update update-city="$CURENTLOCATION"
        $EWW_CMD update msg-show="false"
    else
        $EWW_CMD update update-city="$CITY"
        $EWW_CMD update msg-show="false"
    fi
fi

