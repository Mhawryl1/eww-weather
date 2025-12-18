#!/usr/bin/env bash

EWW_CMD=$(eww -c . get EWW_CMD | tr -d '"')

if command -v xdotool >/dev/null; then
    pos=($xdotool getmouselocation)
elif command -v hyprctl >/dev/null; then
    pos=$(hyprctl cursorpos)
else
    echo "Mouse position not available"
fi
$EWW_CMD update mousepos="${pos}"

