#!/usr/bin/bash

angle=$(eww -c ~/.config/eww/clock get rotate-angle)
CITY="$(/usr/bin/eww -c ~/.config/eww/clock get update-city)"

if [[ $CITY == "null" || -z $CITY ]]; then
    CITY="London"
fi

# Start the weather request in the background and capture its PID
WEATHER_FILE=$(mktemp)
~/.config/eww/clock/bin/weather -c ${CITY} -u METRIC | grep -v "^${CITY}$" > "$WEATHER_FILE" &
WEATHER_PID=$!

# While the weather command is still running, rotate the angle
while kill -0 "$WEATHER_PID" 2>/dev/null; do
    sleep 0.01  # 10ms
    angle=$(( (angle + 1) % 360 ))
    eww -c ~/.config/eww/clock update rotate-angle=$angle
done
# Read the weather output once the command finished
WEATHER=$(<"$WEATHER_FILE")
rm "$WEATHER_FILE"

resp_code=$(echo "$WEATHER" | jq -r '.cod') || {
    eww -c ~/.config/eww/clock update msg-show="true"
    eww -c ~/.config/eww/clock update message="Server error. Check internet connection."
    exit 1
}
if [[ $resp_code == 200 ]]; then
    # Update eww widgets
    eww -c ~/.config/eww/clock update JSON="$WEATHER"
    eww -c ~/.config/eww/clock update wind-icon="$(~/.config/eww/clock/scripts/wind_dir)"
    eww -c ~/.config/eww/clock update msg-show="false"
    sh ~/.config/eww/clock/scripts/tempOverDay.sh
    maxtmp=$(eww -c ~/.config/eww/clock get max-temp)
    sh ~/.config/eww/clock/scripts/temp_anim.sh "$maxtmp"
    eww -c ~/.config/eww/clock update temp-svg="./img/temp24h.svg"
elif [[ $resp_code == 404 ]]; then
    eww -c ~/.config/eww/clock update message="$(echo "$WEATHER" | jq -r '.message')"
    eww -c ~/.config/eww/clock update msg-show="true"
fi
