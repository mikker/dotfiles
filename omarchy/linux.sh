#!/usr/bin/env bash
set -euo pipefail

source "$DOTFILES_ROOT/script/lib.sh"

die() {
  echo "FAIL: $1" >&2
  exit 1
}

adopt_config_path() {
  local source="$1"
  local dest="$2"

  if same_link "$dest" "$source"; then
    echo "Already linked $dest"
    return
  fi

  if path_exists "$dest"; then
    if [[ -f "$source" && -f "$dest" ]] && cmp -s "$source" "$dest"; then
      remove_path "$dest"
    elif [[ -d "$source" && -d "$dest" ]] && diff -qr --exclude=.DS_Store "$source" "$dest" >/dev/null; then
      remove_path "$dest"
    else
      die "refusing to replace changed Omarchy config: $dest"
    fi
  fi

  link_path "$source" "$dest"
}

while IFS= read -r source; do
  relative="${source#$DOTFILES_ROOT/omarchy/config/}"
  adopt_config_path "$source" "$HOME/.config/omarchy/$relative"
done < <(find "$DOTFILES_ROOT/omarchy/config" -type f -print | sort)

while IFS= read -r source; do
  relative="${source#$DOTFILES_ROOT/omarchy/hypr/}"
  adopt_config_path "$source" "$HOME/.config/hypr/$relative"
done < <(find "$DOTFILES_ROOT/omarchy/hypr" -type f -print | sort)

adopt_config_path "$DOTFILES_ROOT/omarchy/fontconfig/fonts.conf" "$HOME/.config/fontconfig/fonts.conf"

while IFS= read -r source; do
  adopt_config_path "$source" "$HOME/.config/omarchy/plugins/${source##*/}"
done < <(find "$DOTFILES_ROOT/omarchy/plugins" -mindepth 1 -maxdepth 1 -type d -print | sort)

while read -r plugin_id plugin_url; do
  [[ -n "$plugin_id" && "$plugin_id" != \#* ]] || continue
  if [[ -d "$HOME/.config/omarchy/plugins/$plugin_id" ]]; then
    echo "Omarchy plugin already installed: $plugin_id"
  else
    omarchy plugin add "$plugin_url" --yes
  fi
done < "$DOTFILES_ROOT/omarchy/plugins/git"

"$DOTFILES_ROOT/bin/omarchy-hyprland-borders-install"
"$DOTFILES_ROOT/bin/omarchy-mekanikos-fonts-set"
