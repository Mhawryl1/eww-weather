#!/usr/bin/bash

hover=$(eww -c ~/.config/eww/clock get HOVER_STATE)
if [ $hover == true ]; then
    roatation=$(eww -c ~/.config/eww/clock get sun-rotation)
    roatation=$((roatation+1))
    if [ $roatation -gt 100  ]; then
        roatation=0
    fi

    eww -c ~/.config/eww/clock update sun-rotation=$roatation
    echo $roatation
fi
