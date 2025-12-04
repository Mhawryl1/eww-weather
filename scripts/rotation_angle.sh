#!/usr/bin/env bash


angle=$(eww -c ~/.config/eww/clock get rotate-angle)

angle=$(( (angle + 1) % 360 ))
#eww -c ~/.config/eww/clock update rotate-angle=$angle echo $angle
