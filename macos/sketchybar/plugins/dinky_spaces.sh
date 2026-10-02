#!/usr/bin/env bash

# Refreshes every workspace item (space.<workspace>, added in sketchybarrc) in one sketchybar call.
# The focused workspace gets the active background, the workspace showing on the other display a fainter
# one, and every workspace a label with the icons of its apps. A workspace on a display other than the main
# one shows as an arrow. Written for macOS's bash 3.2.

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/plugins/icon_map.sh"

DINKY="$HOME/.local/bin/dinky"

# Outline the requested workspace until dinky confirms the switch. A burst of
# requests moves the outline without flashing the settled highlight on each target.
if [ "$SENDER" = dinky_workspace_changing ] && [ -n "$DINKY_DISPLAY" ] && [ -n "$DINKY_WORKSPACE" ]; then
  args=()
  for workspace in $("$DINKY" list-workspaces --monitor "$DINKY_DISPLAY" 2>/dev/null); do
    item="space.$workspace"
    if [ "$workspace" = "$DINKY_WORKSPACE" ]; then
      args+=(--set "$item" background.drawing=on background.color=$TRANSPARENT
        background.border_width=1 background.border_color=$SPACE_SWITCHING_BORDER_COLOR
        icon.color=$SPACE_ACTIVE_COLOR label.color=$SPACE_ACTIVE_COLOR)
    else
      args+=(--set "$item" background.drawing=off background.border_width=0
        icon.color=$SPACE_INACTIVE_COLOR label.color=$SPACE_INACTIVE_COLOR)
    fi
  done
  [ ${#args[@]} -gt 0 ] && sketchybar "${args[@]}"
  exit 0
fi

# "<workspace>|<app>" per window, on any workspace of any display.
windows=$("$DINKY" list-windows --all --format '%{workspace}|%{app-name}' 2>/dev/null)

args=()
while read -r workspace focused visible is_main; do
  [ -n "$workspace" ] || continue
  item="space.$workspace"
  if [ "$is_main" = true ]; then
    args+=(--set "$item" icon="$workspace")
  else
    args+=(--set "$item" icon="↖")
  fi

  if [ "$focused" = true ]; then
    args+=(--set "$item" background.drawing=on background.color=$SPACE_ACTIVE_BG_COLOR background.border_width=0
      icon.color=$SPACE_ACTIVE_COLOR label.color=$SPACE_ACTIVE_COLOR)
  elif [ "$visible" = true ]; then
    args+=(--set "$item" background.drawing=on background.color=$ITEM_BG_COLOR background.border_width=0
      icon.color=$SPACE_ACTIVE_COLOR label.color=$SPACE_ACTIVE_COLOR)
  else
    args+=(--set "$item" background.drawing=off background.border_width=0
      icon.color=$SPACE_INACTIVE_COLOR label.color=$SPACE_INACTIVE_COLOR)
  fi

  icons=""
  while IFS= read -r app; do
    [ -n "$app" ] || continue
    __icon_map "$app"
    [ "$icon_result" != ":default:" ] && icons+="$icon_result"
  done <<<"$(printf '%s\n' "$windows" | grep "^$workspace|" | cut -d'|' -f2- | sort -u)"

  if [ -n "$icons" ]; then
    args+=(--set "$item" label="$icons" label.drawing=on)
  else
    args+=(--set "$item" label.drawing=off)
  fi
done <<<"$("$DINKY" list-workspaces --all \
  --format '%{workspace} %{workspace-is-focused} %{workspace-is-visible} %{monitor-is-main}' 2>/dev/null)"

[ ${#args[@]} -gt 0 ] && sketchybar "${args[@]}"
