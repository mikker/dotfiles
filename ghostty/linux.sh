#!/usr/bin/env bash
set -euo pipefail

ghostty_config="$HOME/.config/ghostty/config"
dotfiles_include='config-file = ?"~/.dotfiles/ghostty/config"'

mkdir -p "$(dirname "$ghostty_config")"
touch "$ghostty_config"

if grep -Fqx "$dotfiles_include" "$ghostty_config"; then
  echo "Ghostty dotfiles config already included"
  exit 0
fi

printf '\n# Personal dotfiles\n%s\n' "$dotfiles_include" >> "$ghostty_config"
echo "Included dotfiles config from $ghostty_config"
