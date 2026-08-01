#!/bin/bash
while ! eww ping; do
    sleep 0.1
done
eww update username="$(whoami)"
