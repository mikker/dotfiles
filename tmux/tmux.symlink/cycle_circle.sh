#!/usr/bin/env bash

current_title="$(tmux display-message -p '#{window_name}')"
clean_title="$(printf '%s\n' "$current_title" | sed 's/ [🟢🟡🔴]$//')"
current_circle="$(tmux show-options -gqv @circle_state)"

case "$current_circle" in
    "🟡") new_circle='' ;;
    *) new_circle='🟡' ;;
esac

tmux set-option -gq @circle_state "$new_circle"
tmux rename-window "${clean_title}${new_circle:+ $new_circle}"
