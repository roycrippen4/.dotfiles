#!/usr/bin/env sh

# Check if wlogout is already running
if pgrep -x "wlogout" >/dev/null; then
	killall wlogout
	exit 0
fi

wlogout --protocol layer-shell
