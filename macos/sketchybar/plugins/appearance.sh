#!/bin/bash

[ "$SENDER" = "appearance_changed" ] || exit 0

source "$CONFIG_DIR/colors.sh"

# Recolor existing items in place. Reloading the config destroys and recreates
# them, which loses workspace and app state while their providers are unavailable.
args=(
  --bar color="$BAR_COLOR"
  --default icon.color="$DEFAULT_ICON_COLOR" label.color="$DEFAULT_LABEL_COLOR"
  --set chevron icon.color="$DEFAULT_ICON_COLOR"
  --set front_app label.color="$DEFAULT_LABEL_COLOR"
  --set front_app_layout icon.color="$FRONT_APP_LAYOUT_ICON_COLOR" background.color="$FRONT_APP_LAYOUT_BG_COLOR"
  --set doing label.color="$DOING_LABEL_COLOR" background.color="$DOING_BG_COLOR"
  --set calendar_event icon.color="$CAL_EVENT_ICON_COLOR" label.color="$CAL_EVENT_LABEL_COLOR" background.color="$CAL_EVENT_BG_COLOR"
  --set clock icon.color="$CLOCK_COLOR" label.color="$CLOCK_COLOR"
)

while IFS= read -r item; do
  args+=(--set "$item" icon.highlight_color="$SPACE_HIGHLIGHT_COLOR")
done < <(sketchybar --query bar | jq -r '.items[] | select(startswith("space."))')

sketchybar "${args[@]}"
"$HOME/.config/borders/bordersrc"
sketchybar --update
