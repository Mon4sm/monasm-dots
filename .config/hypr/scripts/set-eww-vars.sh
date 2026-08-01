#!/bin/bash
while ! eww ping >/dev/null 2>&1; do
    sleep 0.5
done
eww update username="$(whoami)"
