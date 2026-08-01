#!/bin/bash

BAT=$(for b in /sys/class/power_supply/BAT*; do [ -e "$b/capacity" ] && echo "$b" && break; done)

[ -z "$BAT" ] && exit 0

battery_percentage=$(cat "$BAT/capacity")

battery_status=$(cat "$BAT/status")

battery_icons=("󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰁹" "󰁹")

charging_icon="󰂄"

icon_index=$((battery_percentage / 10))
battery_icon=${battery_icons[icon_index]}

if [ "$battery_status" = "Charging" ]; then
	battery_icon="$charging_icon"
fi

echo "$battery_percentage% $battery_icon"
