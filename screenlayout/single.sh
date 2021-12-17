#!/bin/sh

MONITORS=$(xrandr --listmonitors | grep -e DP2-1 -e DP2-3 | wc -l)

if [[ $MONITORS -eq 2 ]]; then
  xrandr \
    --output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
    --output DP2-3 --mode 1920x1080 --pos 0x0 --rotate normal \
    --output DP2-1 --mode 1920x1080 --pos 0x0 --rotate normal
fi

if [[ -e $XDG_RUNTIME_DIR/leftwm/commands.pipe ]]; then
  echo "SoftReload" >> $XDG_RUNTIME_DIR/leftwm/commands.pipe
fi
