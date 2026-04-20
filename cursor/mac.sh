#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/script/lib.sh"

link_path "cursor/settings.json" "$HOME/Library/Application Support/Cursor/User/settings.json"
