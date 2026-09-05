#!/bin/bash

DEV=$(nmcli -t -f DEVICE,TYPE device | grep ':wifi$' | cut -d: -f1 | head -n1)

[ -n "$DEV" ] && nmcli device disconnect "$DEV"
