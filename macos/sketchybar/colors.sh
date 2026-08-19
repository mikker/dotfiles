#!/usr/bin/env bash

export TRANSPARENT=0x00000000
export BAR_COLOR=$TRANSPARENT

# Appearance palettes. The original colors are the dark palette; the light
# palette keeps the same roles with darker, higher-contrast counterparts.
if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q '^Dark$'; then
  export RED=0xfffda7a6
  export GREEN=0xffa6da95
  export BLUE=0xff8aadf4
  export YELLOW=0xffffe4bf
  export ORANGE=0xfff5a97f

  export TEXT_PRIMARY=0xffffffff
  export TEXT_MUTED=0xffcad3f5
  export ITEM_BG_COLOR=0x22ffffff
  export ACCENT_TRANSPARENT=0x44ffffff
else
  export RED=0xffd20f39
  export GREEN=0xff287a3e
  export BLUE=0xff1e66f5
  export YELLOW=0xff9a6700
  export ORANGE=0xffc2410c

  export TEXT_PRIMARY=0xff1e1e2e
  export TEXT_MUTED=0xff666666
  export ITEM_BG_COLOR=0x1f000000
  export ACCENT_TRANSPARENT=0x26000000
fi

# Semantic roles shared by SketchyBar and borders.
export ACCENT=$TEXT_PRIMARY

export DEFAULT_ICON_COLOR=$TEXT_PRIMARY
export DEFAULT_LABEL_COLOR=$TEXT_PRIMARY

export SPACE_ACTIVE_COLOR=$ACCENT
export SPACE_ACTIVE_BG_COLOR=$ACCENT_TRANSPARENT
export SPACE_HIGHLIGHT_COLOR=$ACCENT
export SPACE_INACTIVE_COLOR=$TEXT_MUTED

export FRONT_APP_LAYOUT_ICON_COLOR=$BLUE
export FRONT_APP_LAYOUT_BG_COLOR=$ITEM_BG_COLOR

export CLOCK_COLOR=$TEXT_MUTED

export VOLUME_COLOR=$TEXT_MUTED

export BATTERY_COLOR_NORMAL=$TEXT_MUTED
export BATTERY_COLOR_WARNING=$YELLOW
export BATTERY_COLOR_LOW=$ORANGE
export BATTERY_COLOR_CRITICAL=$RED
export BATTERY_COLOR_CHARGING=$GREEN

export CAL_EVENT_ICON_COLOR=$RED
export CAL_EVENT_LABEL_COLOR=$TEXT_PRIMARY
export CAL_EVENT_BG_COLOR=$ITEM_BG_COLOR

export FUT_AGENT_WORKING_COLOR=$YELLOW
export FUT_AGENT_WAITING_COLOR=$RED

export THINGS_TODO_ICON_COLOR=$YELLOW
export THINGS_TODO_LABEL_COLOR=$TEXT_PRIMARY

export BORDER_ACTIVE_COLOR=$BLUE
export BORDER_BACKGROUND_COLOR=$TRANSPARENT
