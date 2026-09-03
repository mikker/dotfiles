#!/usr/bin/env bash
set -euo pipefail

source "$DOTFILES_ROOT/script/lib.sh"

die() {
  echo "FAIL: $1" >&2
  exit 1
}

while IFS= read -r source; do
  dest="$HOME/.config/omarchy/themes/${source##*/}"

  if same_link "$dest" "$source"; then
    echo "Already linked $dest"
    continue
  fi

  if path_exists "$dest"; then
    if [[ -d "$dest" ]] && diff -qr --exclude=.DS_Store "$source" "$dest" >/dev/null; then
      remove_path "$dest"
    else
      die "refusing to replace changed Omarchy theme: $dest"
    fi
  fi

  link_path "$source" "$dest"
done < <(find "$DOTFILES_ROOT/omarchy-themes" -mindepth 1 -maxdepth 1 -type d -print | sort)
