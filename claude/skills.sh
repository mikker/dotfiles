#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/script/lib.sh"

for skill_file in "$DOTFILES_ROOT"/agents.symlink/skills/*/SKILL.md \
                  "$DOTFILES_ROOT"/agents.symlink/skills/*/*/SKILL.md; do
  [[ -f "$skill_file" ]] || continue

  source_path="$(dirname "$skill_file")"
  dest="$HOME/.claude/skills/${source_path##*/}"

  # Keep existing links (including relative ones) that already point to this skill.
  if [[ -L "$dest" && "$dest" -ef "$source_path" ]]; then
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
