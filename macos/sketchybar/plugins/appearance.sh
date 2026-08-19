#!/bin/sh

# A reload reruns colors.sh and updates every item without restarting the
# SketchyBar service. Ignore forced updates to avoid a reload loop.
if [ "$SENDER" = "appearance_changed" ]; then
  "$HOME/.config/borders/bordersrc"
  sketchybar --reload
fi
