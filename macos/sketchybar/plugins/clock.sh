#!/bin/sh

source "$CONFIG_DIR/colors.sh"

if [ -e "${XDG_STATE_HOME:-$HOME/.local/state}/on-air/active" ]; then
  label="09 Jan 09.41"
else
  label="$(date '+%d %b %H.%M')"
fi

sketchybar --set "$NAME" label="$label" icon.color="$CLOCK_COLOR" label.color="$CLOCK_COLOR"
