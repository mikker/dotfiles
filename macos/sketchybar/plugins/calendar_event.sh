#!/bin/sh

source "$CONFIG_DIR/colors.sh"

# Get next timed event today (excluding all-day events)
OUTPUT=$(icalBuddy -n -nc -npn -ea -li 1 -tf '%H:%M' -df '' -b '•' eventsToday 2>/dev/null)

if [ -n "$OUTPUT" ] && [ "$OUTPUT" != "" ]; then
  # Parse the output - format is "• title\n    HH:MM - HH:MM"
  TITLE=$(echo "$OUTPUT" | head -1 | sed 's/^•[[:space:]]*//')
  TIME=$(echo "$OUTPUT" | tail -1 | grep -o '^[[:space:]]*[0-9][0-9]:[0-9][0-9]' | xargs)

  if [ -n "$TIME" ]; then
    LABEL="$TIME $TITLE"
  else
    LABEL="$TITLE"
  fi
else
  LABEL=""
fi

# Update sketchybar - adjust padding based on content
if [ -z "$LABEL" ]; then
  # Icon only - centered padding accounting for internal icon-label spacing
  # Shift slightly right to compensate for internal spacing
  sketchybar --set "$NAME" \
    icon="󰃮" \
    icon.color="$RED" \
    icon.padding_left=10 \
    icon.padding_right=7 \
    label="" \
    label.padding_right=0
else
  # Icon with label - normal padding
  sketchybar --set "$NAME" \
    icon="󰃮" \
    icon.color="$RED" \
    icon.padding_left=10 \
    icon.padding_right=10 \
    label="$LABEL" \
    label.color="$WHITE" \
    label.padding_right=10
fi

