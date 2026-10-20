#!/bin/sh

# Some events send additional information specific to the event in the $INFO
# variable. E.g. the front_app_switched event sends the name of the newly
# focused application in the $INFO variable:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

DINKY="${DOTFILES:-$HOME/.dotfiles}/bin/dinky"

# Apps dinky leaves alone: the [[rules]] in ~/.config/dinky/dinky.toml float every window of these.
# They show the ignored icon instead of a layout, as does an app with no window at all, such as Finder
# while the desktop is focused. Keep this in step with the rules.
IGNORED_APPS="com.apple.finder com.apple.systempreferences com.apple.Preview com.apple.QuickTimePlayerX com.brnbw.Tuna"
IGNORED_ICON="󰈉"

ignored() {
  case " $IGNORED_APPS " in *" $1 "*) return 0 ;; esac
  return 1
}

# The workspace's layout, then the window's container: "󰕴 " for a tiled master stack. A dwindle workspace,
# the default, shows the container alone, as before.
get_layout_icon() {
  ROW=$("$DINKY" list-windows --focused --format '%{app-bundle-id}|%{workspace-layout}|%{window-layout}' 2>&1)
  if [ $? -ne 0 ]; then
    # The front app has no window (the desktop), or dinky is not running: nothing to show for the latter.
    case "$ROW" in *"no window is focused"*) echo "$IGNORED_ICON" ;; *) echo "" ;; esac
    return
  fi
  BUNDLE_ID=${ROW%%|*}
  REST=${ROW#*|}
  WORKSPACE_LAYOUT=${REST%%|*}
  LAYOUT=${REST#*|}
  if ignored "$BUNDLE_ID"; then
    echo "$IGNORED_ICON"
    return
  fi
  case "$WORKSPACE_LAYOUT" in
  master) WORKSPACE_ICON="󰕴" ;;
  scrolling) WORKSPACE_ICON="󰕬" ;;
  fixed) WORKSPACE_ICON="󰕰" ;;
  *) WORKSPACE_ICON="" ;;
  esac
  case "$LAYOUT" in
  h_accordion) LAYOUT_ICON="" ;;
  v_accordion) LAYOUT_ICON="" ;;
  h_tiles) LAYOUT_ICON="" ;;
  v_tiles) LAYOUT_ICON="" ;;
  floating) LAYOUT_ICON="󰉈" ;;
  *) LAYOUT_ICON="" ;;
  esac
  if [ -n "$WORKSPACE_ICON" ] && [ -n "$LAYOUT_ICON" ]; then
    echo "$WORKSPACE_ICON $LAYOUT_ICON"
  else
    echo "$WORKSPACE_ICON$LAYOUT_ICON"
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
