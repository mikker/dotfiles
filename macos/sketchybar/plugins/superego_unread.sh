#!/bin/sh
# Superego's unread threads (finished, failed or needing you, not yet seen), beside Fut's.

CONFIG_DIR=${CONFIG_DIR:-$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)}

source "$CONFIG_DIR/colors.sh"

SUPEREGO="$HOME/.local/bin/superego"

hide_indicator() {
  sketchybar --set superego_unread \
    drawing=on \
    width=0 \
    icon.drawing=off \
    label.drawing=off
}

if [ ! -x "$SUPEREGO" ]; then
  hide_indicator
  exit 0
fi

COUNT=$("$SUPEREGO" unread --count 2>/dev/null) || {
  hide_indicator
  exit 0
}

if [ "$COUNT" -gt 0 ] 2>/dev/null; then
  sketchybar --set superego_unread \
    drawing=on \
    width=dynamic \
    icon.drawing=on \
    icon.color="$SUPEREGO_UNREAD_COLOR" \
    label.drawing=on \
    label="$COUNT" \
    label.color="$SUPEREGO_UNREAD_COLOR"
else
  hide_indicator
fi
