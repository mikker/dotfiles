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

# Hide widget when no todos, show when there are todos
if [ "$TODO" = "No todos" ] || [ "$TODO" = "" ]; then
  sketchybar --set "$NAME" drawing=off
else
  sketchybar --set "$NAME" drawing=on icon=":things:" icon.color="$YELLOW" label="$TODO" label.color="$WHITE" \
    icon.font="sketchybar-app-font:Regular:14.0" 
fi
