#!/bin/bash

KB=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main==true) | .name' | head -n1)
[ -z "$KB" ] && KB=$(hyprctl devices -j | jq -r '.keyboards[0].name')

hyprctl switchxkblayout "$KB" "${1:-next}"
