#!/usr/bin/env bash
EWW_CMD=$(eww -c . get EWW_CMD | tr -d '"')

angle=$($EWW_CMD get rotate-angle)
CITY="$($EWW_CMD get update-city)"

if [[ $CITY == "null" || -z $CITY ]]; then
    CITY="London"
fi

# Start the weather request in the background and capture its PID
WEATHER_FILE=$(mktemp)
~/.config/eww/clock/bin/fetch -c ${CITY} -u METRIC > "$WEATHER_FILE" &
WEATHER_PID=$!
# While the weather command is still running, rotate the angle
while kill -0 "$WEATHER_PID" 2>/dev/null; do
    sleep 0.01  # 10ms
    angle=$(( (angle + 1) % 360 ))
    $EWW_CMD update rotate-angle=$angle
done
# Read the weather output once the command finished
WEATHER=$(<"$WEATHER_FILE")
rm "$WEATHER_FILE"

resp_code=$(echo "$WEATHER" | jq -r '.cod') || {
    $EWW_CMD update msg-show="true"
    if [[ -z $WEATHER  ]]; then
        $EWW_CMD update message="Can't reach weather server. Check your internet connection."
    else
        $EWW_CMD update message="$WEATHER"
    fi
    exit 1
}
if [[ $resp_code == 200 ]]; then
    # Update eww widgets
    $EWW_CMD update JSON="$WEATHER"
    $EWW_CMD update wind-icon="$(~/.config/eww/clock/scripts/wind_dir.sh)"
    $EWW_CMD update msg-show="false"
    sh ~/.config/eww/clock/scripts/tempOverDay.sh
    tmp=$(echo "$WEATHER" | jq -r '.list[0].main.temp')
    sh ~/.config/eww/clock/scripts/temp_anim.sh "$tmp"
    if [[ $(stat -c %s ./img/temp.svg) -lt 510 ]]; then
        curl https://raw.githubusercontent.com/Mhawryl1/eww-weather/refs/heads/master/img/temp.svg -o  ./img/temp.svg
    fi
    $EWW_CMD update temp-svg="./img/temp.svg"
    # if [[ $(stat -c %s ./img/temp24.svg ) -lt 6000 ]]; then
    #     curl https://raw.githubusercontent.com/Mhawryl1/eww-weather/refs/heads/master/img/temp24h.svg -o  ./img/temp24h.svg
    # fi
    $EWW_CMD update temp24-svg="./img/temp24h.svg"
    $EWW_CMD update message=""
elif [[ $resp_code == 404 ]]; then
    $EWW_CMD update message="$(echo "$WEATHER" | jq -r '.message')"
    $EWW_CMD update msg-show="true"
fi
