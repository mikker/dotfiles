#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/script/lib.sh"

link_path "pi/settings.json" "$HOME/.pi/agent/settings.json"
link_path "pi/keybindings.json" "$HOME/.pi/agent/keybindings.json"
