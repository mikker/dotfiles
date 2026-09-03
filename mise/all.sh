#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/script/lib.sh"

link_path "mise/config.toml" "$HOME/.config/mise/config.toml"
if command_exists mise; then
  mise install

  # Some upstream Linux Ruby archives contain a build-machine RUNPATH. Point
  # the executable at the library shipped beside it when that happens.
  if [[ "$(uname -s)" == Linux ]] && command_exists patchelf; then
    ruby_bin="$(mise where ruby 2>/dev/null)/bin/ruby"
    if [[ -x "$ruby_bin" ]] && ldd "$ruby_bin" 2>/dev/null | grep -q 'libruby.*not found'; then
      patchelf --set-rpath '$ORIGIN/../lib' "$ruby_bin"
    fi
  fi
else
  echo "Skipping runtime install; mise is not installed"
fi
