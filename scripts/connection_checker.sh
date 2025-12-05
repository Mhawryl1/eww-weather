#!/bin/bash
ping -c 1  "www.google.com" || {
    eww -c ~/.config/eww/clock update connected=true
    exit 1
}
eww -c ~/.config/eww/clock update connected=false
sh ~/.config/eww/clock/scripts/get_geolocation.sh
sh ~/.config/eww/clock/scripts/update_city.sh
