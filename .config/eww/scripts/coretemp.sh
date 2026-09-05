#!/bin/bash

HW=""
for h in /sys/class/hwmon/hwmon*; do
    [ -r "$h/name" ] || continue
    case "$(cat "$h/name")" in
        coretemp|k10temp|zenpower|k8temp|cpu_thermal) HW="$h"; break;;
    esac
done
if [ -z "$HW" ]; then
    for h in /sys/class/hwmon/hwmon*; do
        [ -r "$h/name" ] || continue
        case "$(cat "$h/name")" in
            acpitz) HW="$h"; break;;
        esac
    done
fi

rank_pkg() {
    case "$1" in
        "Package id "*) echo 5;;
        "Tdie") echo 4;;
        "Tctl") echo 3;;
        "Composite") echo 2;;
        "CPU"*) echo 1;;
        *) echo 0;;
    esac
}

pkg=0
pkg_rank=0
cores=""

if [ -n "$HW" ]; then
    for lf in "$HW"/temp*_label; do
        [ -r "$lf" ] || continue
        base=${lf%_label}
        [ -r "${base}_input" ] || continue
        lbl=$(cat "$lf")
        val=$(( $(cat "${base}_input") / 1000 ))

        r=$(rank_pkg "$lbl")
        if [ "$r" -gt "$pkg_rank" ]; then
            pkg_rank=$r
            pkg=$val
        fi

        case "$lbl" in
            "Core "*|Tccd*) cores="${cores:+$cores,}{\"label\":\"$lbl\",\"temp\":$val}";;
        esac
    done

    if [ "$pkg" = 0 ] && [ -r "$HW/temp1_input" ]; then
        pkg=$(( $(cat "$HW/temp1_input") / 1000 ))
    fi
fi

printf '{"package":%s,"cores":[%s]}\n' "$pkg" "$cores"
