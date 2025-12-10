#!/bin/bash

JSON=$(eww -c ~/.config/eww/clock get JSON)
JSON=$(printf "%s\n" "$JSON" | sed '1s/^[^{]*//')

i=0
time=()
day=()
while [ $i -lt 40 ] ; do
    temp+=$(echo $JSON | jq -r ".list[${i}].main.temp" )
    temp+=" "
    item=$(echo $JSON | jq -r ".list[${i}].dt_txt" | xargs -I{} date -d "{}" "+%H:%M")
    time+=($item)
    item=$(echo $JSON | jq -r ".list[${i}].dt_txt" | xargs -I{} date -d "{}" "+%e-%m")
    day+=($item)
    i=$((i+1))
done

i=0
max_value=0
SVG=~/.config/eww/clock/img/temp24h.svg
cat $SVG | sed 's/<path d=.*//'> "${SVG}.tmp"
SVGCONTENT='<path d="M'
CIRCLE=""
for t in $temp; do
    if (( $( echo "$t > $max_value"  | bc -l) )); then
        max_value=$t
    fi

    t=$(echo "-1 * $t" | bc -l)
    if (( i % 3 != 0 )); then
        CIRCLE+="<circle cx=\"$(( i*4 ))\" cy=\"$t\" r=\"0.5\" fill=\"red\" />"
        CIRCLE+="<text x=\"$(( i*4 ))\" y=\"$t\" font-size=\"2\" fill=\"white\"> ${time[$i]}</text>"
    fi
     if [[ "${time[$i]}"  == "00:00" ]]; then
       VERTIAL_LINE+="<line x1=\"$(( i*4 ))\" y1= \"-60\" x2=\"$(( i*4 ))\" y2= \"60\" stroke-width=\".1\" stroke=\"rgba(173, 255, 47, 0.5)\" />"
       VERTIAL_LINE+="<text id=\"day\" x=\"$(( i*4 -3 ))\" y=\"20\" font-size=\"3\" fill=\"white\"> ${day[$i]}</text>"
     fi

    if [ $i == 0 ]; then
        SVGCONTENT+="0 $t"
    else
        x=$(( i*4 ))
        SVGCONTENT+="L ${x} ${t} "
    fi

    (( i++ ))
done


SVGCONTENT+='" stroke-width=".5"  stroke="red" fill="none" /> '
SVGCONTENT+=$(echo $CIRCLE)
SVGCONTENT+=$(echo $VERTIAL_LINE)
SVGCONTENT+="</svg>"
echo $SVGCONTENT >> "${SVG}.tmp"
SVGCONTENT=$(awk 'NF' "${SVG}.tmp")
if(( $( echo "$max_value > 30"  | bc -l) )); then
    SVGCONTENT=$(cat "${SVG}.tmp" | sed -E "s/(viewBox=\"[0-9.-]+ )[0-9.-]+/\1-58/")
    SVGCONTENT=$(echo ${SVGCONTENT} | sed -E "s/(text id=\"day\" x=\"[0-9]+\" y=)\"[0-9]+/\1\"-10/g")
elif(( $( echo "$max_value > 20"  | bc -l) )); then
    SVGCONTENT=$(cat "${SVG}.tmp" | sed -E "s/(viewBox=\"[0-9.-]+ )[0-9.-]+/\1-40/")
    SVGCONTENT=$(echo ${SVGCONTENT} | sed -E "s/(text id=\"day\" x=\"[0-9]+\" y=)\"[0-9]+/\1\"-10/g")
elif(( $( echo "$max_value > 10"  | bc -l) )); then
    SVGCONTENT=$(cat "${SVG}.tmp" | sed -E "s/(viewBox=\"[0-9.-]+ )[0-9.-]+/\1-36/")
    SVGCONTENT=$(echo ${SVGCONTENT} | sed -E "s/(text id=\"day\" x=\"[0-9]+\" y=)\"[0-9]+/\1\"15/g")
elif(( $( echo "$max_value > 5"  | bc -l) )); then
    SVGCONTENT=$(cat "${SVG}.tmp" | sed -E "s/(viewBox=\"[0-9.-]+ )[0-9.-]+/\1-32/")
    SVGCONTENT=$(echo ${SVGCONTENT} | sed -E "s/(text id=\"day\" x=\"[0-9]+\" y=)\"[0-9]+/\1\"15/g")
elif(( $( echo "$max_value > 0"  | bc -l) )); then
    SVGCONTENT=$(cat "${SVG}.tmp" | sed -E "s/(viewBox=\"[0-9.-]+ )[0-9.-]+/\1-27/")
    SVGCONTENT=$(echo ${SVGCONTENT} | sed -E "s/(text id=\"day\" x=\"[0-9]+\" y=)\"[0-9]+/\1\"15/g")
else
    SVGCONTENT=$(cat "${SVG}.tmp" | sed -E "s/(viewBox=\"[0-9.-]+ )[0-9.-]+/\1-10/")
    SVGCONTENT=$(echo ${SVGCONTENT} | sed -E "s/(text id=\"day\" x=\"[0-9]+\" y=)\"[0-9]+/\1\"20/g")
fi
echo $SVGCONTENT >"${SVG}.tmp"
cat "${SVG}.tmp" > $SVG

eww -c ~/.config/eww/clock update max-temp="$max_value"
