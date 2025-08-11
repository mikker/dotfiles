#!/bin/sh

source "$CONFIG_DIR/colors.sh"

sketchybar --set "$NAME" label="$(date '+%d %b %H.%M')" icon.color="$GREY" label.color="$GREY"