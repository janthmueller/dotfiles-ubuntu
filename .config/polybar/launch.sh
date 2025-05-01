#!/bin/bash

# Kill any existing polybar
killall -q polybar

# Wait until the processes are gone
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch main bar (you can name it "example" or "top" depending on your config)
polybar main 2>&1 | tee -a /tmp/polybar.log & disown

