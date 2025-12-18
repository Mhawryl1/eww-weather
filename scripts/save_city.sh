#!/usr/bin/env bash

city=$(eww -c . get update-city)
echo $city > .save_city.txt
