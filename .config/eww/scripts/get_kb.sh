#!/bin/bash

RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
HYPRLAND_SIGNATURE_ACTUAL="${HYPRLAND_INSTANCE_SIGNATURE:-$(ls -td "$RUNTIME_DIR"/hypr/*/ 2>/dev/null | head -n1 | xargs -r basename)}"
SOCKET="$RUNTIME_DIR/hypr/$HYPRLAND_SIGNATURE_ACTUAL/.socket2.sock"

socat -u UNIX-CONNECT:"$SOCKET" - |
    stdbuf -o0 awk -F '>>|,' '/^activelayout>>/ { print toupper(substr($3, 1, 2)) }'
