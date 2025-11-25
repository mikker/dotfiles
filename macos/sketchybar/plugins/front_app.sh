#!/bin/sh

# Some events send additional information specific to the event in the $INFO
# variable. E.g. the front_app_switched event sends the name of the newly
# focused application in the $INFO variable:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

get_layout_icon() {
  LAYOUT=$(aerospace list-windows --focused --format '%{window-layout}' 2>/dev/null)

  if [ -n "$LAYOUT" ]; then
    case "$LAYOUT" in
    h_accordion) echo "" ;;
    v_accordion) echo "" ;;
    h_tiles) echo "" ;;
    v_tiles) echo "" ;;
    floating) echo "󰉈" ;;
    *) echo "" ;;
    esac
  else
    echo ""
  fi
}

if [ "$NAME" = "front_app" ]; then
  if [ "$SENDER" = "front_app_switched" ]; then
    sketchybar --set "$NAME" label="$INFO"
  fi
elif [ "$NAME" = "front_app_layout" ]; then
  if [ "$SENDER" = "front_app_switched" ] || [ "$SENDER" = "aerospace_mode_changed" ]; then
    ICON=$(get_layout_icon)
    sketchybar --set "$NAME" icon="$ICON"
  fi
fi
