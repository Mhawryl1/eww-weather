#!/usr/bin/env bash
JSON=$(curl -s --fail http://ip-api.com/json/ 2>/dev/null) || JSON=""
CITY=$(echo $JSON | jq -r '.city' 2>/dev/null || echo "")

echo $CITY
