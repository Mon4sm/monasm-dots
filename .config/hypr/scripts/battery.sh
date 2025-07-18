#!/bin/bash

battery_percentage=$(cat /sys/class/power_supply/BAT0/capacity)

battery_status=$(cat /sys/class/power_supply/BAT0/status)

battery_icons=("󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰁹" "󰁹")

charging_icon="󰂄"

icon_index=$((battery_percentage / 10))
battery_icon=${battery_icons[icon_index]}

if [ "$battery_status" = "Charging" ]; then
	battery_icon="$charging_icon"
fi

echo "$battery_percentage% $battery_icon"
