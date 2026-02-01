#!/bin/sh

source "$CONFIG_DIR/colors.sh"

sketchybar --set "$NAME" label="$(date '+%d %b %H.%M')" icon.color="$CLOCK_COLOR" label.color="$CLOCK_COLOR"
