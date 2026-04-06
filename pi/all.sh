#!/bin/bash
set -euo pipefail

mkdir -p "$HOME/.pi/agent"
ln -sf "$HOME/.dotfiles/pi/settings.json" "$HOME/.pi/agent/settings.json"
ln -sf "$HOME/.dotfiles/pi/keybindings.json" "$HOME/.pi/agent/keybindings.json"
