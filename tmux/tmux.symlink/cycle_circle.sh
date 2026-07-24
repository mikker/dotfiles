#!/usr/bin/env bash

current_title="$(tmux display-message -p '#{window_name}')"
clean_title="$(printf '%s\n' "$current_title" | sed 's/ [🟢🟡🔴]$//')"
current_circle="$(tmux show-options -wqv @circle_state)"

case "$current_circle" in
    "🟡") new_circle='' ;;
    *) new_circle='🟡' ;;
esac

if [[ -n "$new_circle" ]]; then
    tmux set-window-option -q @circle_state "$new_circle"
else
    tmux set-window-option -qu @circle_state
fi
tmux rename-window "${clean_title}${new_circle:+ $new_circle}"
