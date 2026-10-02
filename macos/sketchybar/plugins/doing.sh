#!/bin/bash

if [ "$1" = edit ]; then
  touch "$HOME/.doing" && open -t "$HOME/.doing"
  exit $?
fi

# Trim each line, skip blank lines, and join the rest with spaces.
task=$(awk '
  { gsub(/^[[:space:]]+|[[:space:]]+$/, "") }
  NF { text = text (text ? " " : "") $0 }
  END { print text }
' "$HOME/.doing" 2>/dev/null)

sketchybar --set "${NAME:-doing}" label="${task:-Doing…}"
