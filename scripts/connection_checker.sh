#!/bin/bash

if curl -s --head https://google.com | grep "200" >/dev/null; then
    eww -c ~/.config/eww/clock update connected=false
else
    eww -c ~/.config/eww/clock update connected=true
fi
