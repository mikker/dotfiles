#!/bin/sh

CONFIG_DIR=${CONFIG_DIR:-$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)}

source "$CONFIG_DIR/colors.sh"

FUT="/opt/homebrew/bin/fut"
JQ="/opt/homebrew/bin/jq"

hide_indicator() {
  sketchybar --set fut_waiting \
    drawing=on \
    width=0 \
    icon.drawing=off \
    label.drawing=off
}

if [ ! -x "$FUT" ] || [ ! -x "$JQ" ]; then
  hide_indicator
  exit 0
fi

OUTPUT=$($FUT --json agent list 2>/dev/null)

WAITING_COUNT=$(printf '%s\n' "$OUTPUT" | $JQ -er '.result.unread_count' 2>/dev/null) || {
  hide_indicator
  exit 0
}

if [ "$WAITING_COUNT" -gt 0 ] 2>/dev/null; then
  sketchybar --set fut_waiting \
    drawing=on \
    width=dynamic \
    icon.drawing=on \
    icon.color="$FUT_AGENT_WAITING_COLOR" \
    label.drawing=on \
    label="$WAITING_COUNT" \
    label.color="$FUT_AGENT_WAITING_COLOR"
else
  hide_indicator
fi
