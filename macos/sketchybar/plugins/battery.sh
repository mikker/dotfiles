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
  COLOR=$GREY
  ;;
[6-8][0-9])
  ICON=""
  COLOR=$GREY
  ;;
[3-5][0-9])
  ICON=""
  COLOR=$YELLOW
  ;;
[1-2][0-9])
  ICON=""
  COLOR=$ORANGE
  ;;
*)
  ICON=""
  COLOR=$RED
  ;;
esac

if [[ "$CHARGING" != "" ]]; then
  ICON="󱐋"
  COLOR=$GREY
fi

sketchybar --set "$NAME" icon="$ICON" icon.drawing=on icon.color="$COLOR" label="${PERCENTAGE}%" label.color="$COLOR"

