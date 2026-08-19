#!/bin/sh

CONFIG_DIR=${CONFIG_DIR:-$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)}

source "$CONFIG_DIR/colors.sh"

FUT="$HOME/.bin/fut"
JQ="/opt/homebrew/bin/jq"

if [ ! -x "$FUT" ] || [ ! -x "$JQ" ]; then
  sketchybar --set fut_waiting drawing=off
  exit 0
fi

if [ -z "$FUT_SOCKET" ]; then
  FUT_SOCKET=$(/bin/ps -axo command= | /usr/bin/awk '
    /[f]ut / && /daemon run/ {
      for (field = 1; field <= NF; field++) {
        if ($field == "--socket") {
          print $(field + 1)
          exit
        }
        if ($field ~ /^--socket=/) {
          sub(/^--socket=/, "", $field)
          print $field
          exit
        }
      }
    }
  ')
fi

if [ -n "$FUT_SOCKET" ]; then
  OUTPUT=$($FUT --socket "$FUT_SOCKET" --json agent list 2>/dev/null)
else
  OUTPUT=$($FUT --json agent list 2>/dev/null)
fi

WAITING_COUNT=$(printf '%s\n' "$OUTPUT" | $JQ -er '.result.unread_count' 2>/dev/null) || {
  sketchybar --set fut_waiting drawing=off
  exit 0
}

if [ "$WAITING_COUNT" -gt 0 ] 2>/dev/null; then
  sketchybar --set fut_waiting \
    drawing=on \
    icon.color="$FUT_AGENT_WAITING_COLOR" \
    label="$WAITING_COUNT" \
    label.color="$FUT_AGENT_WAITING_COLOR"
else
  sketchybar --set fut_waiting drawing=off
fi
