#!/usr/bin/env bash
EWW_CMD=$(eww -c . get EWW_CMD | tr -d '"')
eww -c ~/.config/eww/clock update hover-state='true'
roatation=$($EWW_CMD get sun-rotation)

while [[ $($EWW_CMD get hover-state) == true ]]; do
    roatation=$((roatation+1))
    if [ $roatation -gt 100  ]; then
        roatation=0
    fi
    $EWW_CMD update sun-rotation=$roatation
    sleep 0.01
done
