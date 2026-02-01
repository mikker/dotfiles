#!/bin/sh

source "$CONFIG_DIR/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case "${PERCENTAGE}" in
9[0-9] | 100)
  ICON=""
  COLOR=$BATTERY_COLOR_NORMAL
  ;;
[6-8][0-9])
  ICON=""
  COLOR=$BATTERY_COLOR_NORMAL
  ;;
[3-5][0-9])
  ICON=""
  COLOR=$BATTERY_COLOR_WARNING
  ;;
[1-2][0-9])
  ICON=""
  COLOR=$BATTERY_COLOR_LOW
  ;;
*)
  ICON=""
  COLOR=$BATTERY_COLOR_CRITICAL
  ;;
esac

if [[ "$CHARGING" != "" ]]; then
  ICON="󱐋"
  COLOR=$BATTERY_COLOR_CHARGING
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%" label.color="$COLOR"
