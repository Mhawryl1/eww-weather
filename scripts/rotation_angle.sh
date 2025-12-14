#!/usr/bin/env bash
EWW_CMD=$(eww -c . get EWW_CMD | tr -d '"')

angle=$($EWW_CMD get rotate-angle)

angle=$(( (angle + 1) % 360 ))
#$EWW_CMD update rotate-angle=$angle echo $angle
