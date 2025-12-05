#!/bin/bash

temp=$1


if [[ $temp == "" ]]; then
    temp="0"
elif (( $( echo "$temp < -40"  | bc -l) )); then
    temp="-40"
elif (( $( echo "$temp > 40"  | bc -l) )); then
    temp="40"
fi
tempnorm=$(echo "($temp * (1.0 / (40*2.0)) + 0.5 )" | bc -l)

#color lero
source ~/.config/eww/clock/scripts/lerp_color.sh

new_color=$(lerp_color "#0000FF"  "#FF5A10" $tempnorm)
lerp() {
    a=$1
    b=$2
    t=$3
    echo "$(echo "$a + ($b - $a) * $t" | bc -l)"
}

result=$(lerp "19.0" "6.0" $tempnorm )
rounded=$(printf "%.2f" "$(echo "$result" | bc)")
SVG=~/.config/eww/clock/img/temp.svg
SVG_COLOR=$(cat $SVG | sed -E "s/path fill=\"#[0-9A-Fa-f]+/path fill=\"${new_color}/")
echo $SVG_COLOR | sed -E "s/id=\"temp\" d=\"M10,20.1839V[0-9.]+/id=\"temp\" d=\"M10,20.1839V${rounded}/" > "${SVG}.tmp"

cat "${SVG}.tmp" > "$SVG"

