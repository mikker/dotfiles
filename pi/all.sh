#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/script/lib.sh"

link_path "pi/keybindings.json" "$HOME/.pi/agent/keybindings.json"

command_exists pi || { echo "Pi is required to install packages" >&2; exit 1; }
node "$DOTFILES_ROOT/pi/packages.mjs"
pi update --extensions
