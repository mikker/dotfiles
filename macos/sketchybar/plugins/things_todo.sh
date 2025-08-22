#!/bin/sh

source "$CONFIG_DIR/colors.sh"

# Get the next todo from Things using AppleScript
TODO=$(osascript -e '
tell application "Things3"
  set todayTodos to to dos of list "Today"
  if (count of todayTodos) > 0 then
    set nextTodo to item 1 of todayTodos
    return name of nextTodo
  else
    return "No todos"
  end if
end tell
' 2>/dev/null)

# Truncate if too long
if [ ${#TODO} -gt 30 ]; then
  TODO="${TODO:0:27}..."
fi

# Show icon only when no todos, show with label when there are todos
if [ "$TODO" = "No todos" ] || [ "$TODO" = "" ]; then
  # Icon only - centered padding accounting for internal icon-label spacing
  # Shift slightly right to compensate for internal spacing
  sketchybar --set "$NAME" \
    drawing=on \
    icon=":things:" \
    icon.color="$YELLOW" \
    icon.padding_left=10 \
    icon.padding_right=7 \
    label="" \
    label.padding_right=0 \
    icon.font="sketchybar-app-font:Regular:14.0"
else
  # Icon with label - normal padding
  sketchybar --set "$NAME" \
    drawing=on \
    icon=":things:" \
    icon.color="$YELLOW" \
    icon.padding_left=10 \
    icon.padding_right=10 \
    label="$TODO" \
    label.color="$WHITE" \
    label.padding_right=10 \
    icon.font="sketchybar-app-font:Regular:14.0"
fi
