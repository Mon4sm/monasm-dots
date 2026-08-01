#!/bin/bash

get_icon(){
  case $1 in
    9[0-9]|100)
      CLASS="BAT1"
      ICON=" "
      ;;
    8[0-9]|7[0-9]|6[5-9])
      CLASS="BAT2"
      ICON=" "
      ;;
    6[0-4]|5[0-9]|4[5-9])
      CLASS="BAT3"
      ICON=" "
      ;;
    4[0-4]|3[0-9]|2[0-9]|1[5-9])
      CLASS="BAT4"
      ICON=" "
      ;;
    *)
      CLASS="BAT5"
      ICON=" "
      ;;
  esac
}

BAT=$(for b in /sys/class/power_supply/BAT*; do [ -e "$b/capacity" ] && echo "$b" && break; done)

while true; do
    if [ -z "$BAT" ]; then
        echo "(box)"
        sleep 5
        continue
    fi
    BATTERY=$(cat "$BAT/capacity")
    STATUS=$(cat "$BAT/status")
    CLASS=""
    ICON=""
    get_icon "$BATTERY"

    if [[ "$STATUS" == "Charging" ]]; then
        CLASS="CHARGING"
    fi

    echo "(box :class \"$CLASS\" \"$ICON\")"
    sleep 1
done
