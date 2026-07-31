#!/bin/bash

BAT=$(for b in /sys/class/power_supply/BAT*; do [ -e "$b/capacity" ] && echo "$b" && break; done)

if [ -z "$BAT" ]; then
    echo "(box)"
    exit 0
fi

battery_percent=$(cat "$BAT/capacity")

status=$(cat "$BAT/status")

echo "(box :class \"bat-bar\" (circular-progress :value ${battery_percent} :hexpand false (eventbox :class \"bat-icon\" :tooltip \"Battery : ${battery_percent}%\" :wrap false \"🔋\")))"
