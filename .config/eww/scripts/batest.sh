#!/bin/bash

BAT=$(for b in /sys/class/power_supply/BAT*; do [ -e "$b/status" ] && echo "$b" && break; done)

read_attr() {
    if [ -e "$BAT/$1" ]; then
        cat "$BAT/$1"
    elif [ -e "$BAT/$2" ]; then
        cat "$BAT/$2"
    else
        echo 0
    fi
}

while true; do
    if [ -z "$BAT" ]; then
        sleep 5
        continue
    fi

    CHARGE_NOW=$(read_attr charge_now energy_now)
    CURRENT_NOW=$(read_attr current_now power_now)
    CURRENT_NOW=${CURRENT_NOW#-}
    CHARGE_FULL=$(read_attr charge_full energy_full)
    STATUS=$(cat "$BAT/status")

    if [ "$CURRENT_NOW" -ne 0 ]; then
        if [[ "$STATUS" == "Discharging" ]]; then
            MINUTES_LEFT=$(( CHARGE_NOW * 60 / CURRENT_NOW ))
            HOURS=$(( MINUTES_LEFT / 60 ))
            MINS=$(( MINUTES_LEFT % 60 ))
            echo "$HOURS h $MINS min left, $STATUS"
        elif [[ "$STATUS" == "Charging" ]]; then
            DIFF=$(( CHARGE_FULL - CHARGE_NOW ))
            MINUTES_TO_FULL=$(( DIFF * 60 / CURRENT_NOW ))
            HOURS=$(( MINUTES_TO_FULL / 60 ))
            MINS=$(( MINUTES_TO_FULL % 60 ))
            echo "$HOURS h $MINS min to full, $STATUS"
        else
            echo "0 h 0 min to full, $STATUS"
        fi
    fi
    sleep 1
done
