#!/usr/bin/env bash


card=$(eww -c . get cond-card)
if [[ $card == 0 ]]; then
    eww -c . update cond-card=1
else
    eww -c . update cond-card=0
fi
