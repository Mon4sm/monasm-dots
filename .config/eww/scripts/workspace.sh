#!/bin/bash

ws(){
    local workspaces=6
    local workspace_icon=()
    local workspace_class=()
    local output=""

    workspace_data=$(hyprctl workspaces -j)
    current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')

    for ((i=1; i<=workspaces; i++)); do
        windows=$(echo "$workspace_data" | jq -r "[.[] | select(.id == ${i})] | .[0]?.windows // 0")
        workspace_icon+=(" ")
        if [[ "$current_workspace" == "$i" ]]; then
            workspace_class+=("visiting")
        elif [[ "$windows" -gt 0 ]]; then
            workspace_class+=("occupied")
        else
            workspace_class+=("free")
        fi
        if [[ "$current_workspace" == "$i" ]]; then
            workspace_icon[$((i-1))]=" "
        fi
    done

    output="(box :class \"ws\" :halign \"end\" :orientation \"h\" :spacing 5 :space-evenly \"false\""
    for i in {1..6}; do
        idx=$((i-1))
        output+=" (eventbox :onclick \"hyprctl dispatch workspace $i\" :cursor \"pointer\" :class \"${workspace_class[$idx]}\" (label :text \"${workspace_icon[$idx]}\"))"
    done
    output+=")"
    /usr/bin/eww update workspaces-output="$output"
}

RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
HYPRLAND_SIGNATURE_ACTUAL="${HYPRLAND_INSTANCE_SIGNATURE:-$(ls -td "$RUNTIME_DIR"/hypr/*/ 2>/dev/null | head -n1 | xargs -r basename)}"
SOCKET="$RUNTIME_DIR/hypr/${HYPRLAND_SIGNATURE_ACTUAL}/.socket2.sock"

stdbuf -oL socat -U - UNIX-CONNECT:"$SOCKET" | while read -r line; do
    case $line in
        "workspace>>"*|"createworkspace>>"*|"destroyworkspace>>"*)
            ws
            ;;
    esac
done
