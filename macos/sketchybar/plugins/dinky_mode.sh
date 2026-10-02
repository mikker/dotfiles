#!/bin/sh

# Shows dinky's binding mode next to the front app's layout, hidden in the main mode. dinky's mode-changed
# hook sends the new mode as $MODE; on startup and other events, ask dinky.

source "$CONFIG_DIR/colors.sh"

mode="$MODE"
[ -n "$mode" ] || mode=$("$HOME/.local/bin/dinky" list-modes --current 2>/dev/null)

if [ -z "$mode" ] || [ "$mode" = main ]; then
  sketchybar --set "$NAME" drawing=off
else
  sketchybar --set "$NAME" drawing=on label="$(printf '%s' "$mode" | tr '[:lower:]' '[:upper:]')"
fi
