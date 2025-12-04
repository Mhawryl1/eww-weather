#!/bin/bash

JSON=$(eww -c ~/.config/eww/clock get JSON)
JSON=$(printf "%s\n" "$JSON" | sed '1s/^[^{]*//')

i=0
while [ $i -lt 40 ] ; do
    temp+=$(echo $JSON | jq -r ".list[${i}].main.temp" )
    temp+=" "
    i=$((i+1))
done

i=0 max_value=0
SVG=~/.config/eww/clock/img/temp24h.svg
cat $SVG | sed 's/<path d=.*//'> "${SVG}.tmp"
SVGCONTENT='<path d="M'
for t in $temp; do
    if (( $( echo "$t > $max_value"  | bc -l) )); then
        max_value=$t
    fi

    t=$(echo "-1 * $t" | bc -l)
    if [ $i == 0 ]; then
        SVGCONTENT+="0 $t"
    else
        x=$(( i*4 ))
        SVGCONTENT+="L ${x} ${t} "
    fi

    (( i++ ))
done


SVGCONTENT+='" stroke-width=".5"  stroke="red" fill="none" /> </svg>'
echo $SVGCONTENT >> "${SVG}.tmp"
SVGCONTENT=$(awk 'NF' "${SVG}.tmp")
if(( $( echo "$max_value > 30"  | bc -l) )); then
    SVGCONTENT=$(cat "${SVG}.tmp" | sed -E "s/(viewBox=\"[0-9.-]+ )[0-9.-]+/\1-50/")
elif(( $( echo "$max_value > 20"  | bc -l) )); then
    SVGCONTENT=$(cat "${SVG}.tmp" | sed -E "s/(viewBox=\"[0-9.-]+ )[0-9.-]+/\1-40/")
elif(( $( echo "$max_value > 10"  | bc -l) )); then
    SVGCONTENT=$(cat "${SVG}.tmp" | sed -E "s/(viewBox=\"[0-9.-]+ )[0-9.-]+/\1-34/")
elif(( $( echo "$max_value > 0"  | bc -l) )); then
    SVGCONTENT=$(cat "${SVG}.tmp" | sed -E "s/(viewBox=\"[0-9.-]+ )[0-9.-]+/\1-27/")
else
    SVGCONTENT=$(cat "${SVG}.tmp" | sed -E "s/(viewBox=\"[0-9.-]+ )[0-9.-]+/\1-10/")
fi
echo $SVGCONTENT > $SVG
#cat "${SVG}.tmp" > $SVG

eww -c ~/.config/eww/clock update max-temp="$max_value"
# <path d="M0 0 L 4 -4.2 L 8 -4" stroke-width=".5"  stroke="red" fill="none" />
