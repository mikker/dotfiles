#!/usr/bin/env bash
# Thank you github.com/cqroot/bubbles.tmux

# $1: option
# $2: default value
tmux_get() {
	local value
	value="$(tmux show -gqv "$1")"
	[ -n "$value" ] && echo "$value" || echo "$2"
}

color_fg=$(tmux_get @tmux_bubbles_color_active 'color0')         # "black"
color_bg_active=$(tmux_get @tmux_bubbles_color_grey 'colour15')  # "white"
color_bg_inactive=$(tmux_get @tmux_bubbles_color_grey 'colour8') # "grey"

tmux set-option -gq status on
tmux set-option -gq status-fg "$color_fg"
tmux set-option -gq status-bg "0"
tmux set-option -gq status-attr none

# $1: modules
# $2: fg_color
# $3: bg_color
make_bubble() {
	echo "#[fg=$3]#[bg=0]#[fg=$2]#[bg=$3]$1#[fg=$3]#[bg=0]"
}

# $1: modules
make_activatable_bubble() {
	local normal_bubble
	local active_bubble
	normal_bubble="$(make_bubble "$1" "$color_fg" "$color_bg_inactive")"
	active_bubble="$(make_bubble "$1" "$color_fg" "$color_bg_active")"

	echo "#{?client_prefix,$active_bubble,$normal_bubble}"
}

tmux set-option -gq status-left ""
tmux set-option -gq status-right " $(make_bubble ' #S ' "$color_fg" "$color_bg_active")"

# *********************************************************
# Window                                                  *
# *********************************************************
tmux set-option -gq window-status-format "#[fg=$color_bg_active,bg=0,bold]  #I #W  "
tmux set-option -gq window-status-current-format "$(make_bubble ' #I #W#{?window_zoomed_flag,󰁌,} ' "$color_fg" "$color_bg_active")"

# *********************************************************
# Others                                                  *
# *********************************************************
tmux set-option -gq mode-style "bg=$color_bg_active,fg=0"
tmux set-option -gq pane-active-border-style "fg=$color_bg_active,bg=0"
tmux set-option -gq clock-mode-colour "$color_bg_active"
