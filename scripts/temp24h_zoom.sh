#!/usr/bin/env bash

EWW_CMD=$(eww -c . get EWW_CMD | tr -d '"')

SVG=$(cat ~/.config/eww/clock/img/temp24h.svg)
pos=$($EWW_CMD get mousepos)
pos_x=$(echo $pos | cut -d',' -f1)
pos_y=$(echo $pos | cut -d',' -f2)

./scripts/update_mouse_pos.sh
current_pos=$($EWW_CMD get mousepos)

current_pos_x=$(echo $current_pos | cut -d',' -f1)
current_pos_y=$(echo $current_pos | cut -d',' -f2)

relative_x=$(echo "$current_pos_x - $pos_x" | bc -l )
relative_y=$(echo "$current_pos_y - $pos_y" | bc -l )

echo "x $relative_x y $relative_y"

SVG_ZOOM=$(echo $SVG | sed -E "s/(viewBox=)\"[0-9.-]+ [0-9.-]+ [0-9.-]+ [0-9.-]+\"/\1\"0 -20 85 27\"/")
echo $SVG_ZOOM > ~/.config/eww/clock/img/temp24h.svg
