#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/script/lib.sh"

for source_path in "$DOTFILES_ROOT/claude/CLAUDE.md" \
                   "$DOTFILES_ROOT/claude/settings.json" \
                   "$DOTFILES_ROOT/claude/statusline-command.sh" \
                   "$DOTFILES_ROOT/claude/commands/"*.md; do
  dest="$HOME/.claude/${source_path#"$DOTFILES_ROOT/claude/"}"

  if same_link "$dest" "$source_path"; then
    continue
  fi

  if path_exists "$dest"; then
    backup="$dest.backup"
    if path_exists "$backup"; then
      backup="$dest.backup.$(date +%Y%m%d%H%M%S)"
    fi
    mv "$dest" "$backup"
    printf 'Backed up %s -> %s\n' "$dest" "$backup"
  fi

  link_path "$source_path" "$dest"
done
