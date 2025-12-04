#!/usr/bin/env bash

json=$(curl -s --fail http://ip-api.com/json/ 2>/dev/null) || json=""
if [ "$json" == "" ] ; then
    city="London"
else
    city=$(echo "$json" | jq -r .city)
fi
echo "$city"
