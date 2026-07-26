#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/script/lib.sh"

link_path "herdr/config.toml" "$HOME/.config/herdr/config.toml"
link_path "herdr/projects" "$HOME/.config/herdr/projects"

if command_exists herdr; then
  herdr plugin link "$DOTFILES_ROOT/herdr/plugins/project-runner" --enabled >/dev/null
fi
