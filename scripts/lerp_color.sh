#!/usr/bin/env bash

hex_to_rgb() {
    local hex=${1#"#"}
    r=$(printf "%d\n"  0x${hex:0:2})
    g=$(printf "%d\n"  0x${hex:2:2})
    b=$(printf "%d\n"  0x${hex:4:2})
}

rgb_to_hex() {
    printf "#%02X%02X%02X\n" "$1" "$2" "$3"
}

lerp_val() {
    # a + (b - a) * t
    echo "$(printf "%.0f" "$(echo "$1 + ($2 - $1) * $3" | bc -l)")"
}

lerp_color() {
    local c1="$1"
    local c2="$2"
    local t="$3"

    # Convert hex 1 → RGB
    hex_to_rgb "$c1"
    local r1=$r g1=$g b1=$b

    # Convert hex 2 → RGB
    hex_to_rgb "$c2"
    local r2=$r g2=$g b2=$b

    # Lerp each channel
    local r3=$(lerp_val "$r1" "$r2" "$t")
    local g3=$(lerp_val "$g1" "$g2" "$t")
    local b3=$(lerp_val "$b1" "$b2" "$t")

    # Convert back to hex
    rgb_to_hex "$r3" "$g3" "$b3"
}
