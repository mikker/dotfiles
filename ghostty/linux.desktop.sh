#!/usr/bin/env bash
set -euo pipefail

ghostty_config="$HOME/.config/ghostty/config"
dotfiles_marker='# Personal dotfiles'
dotfiles_include='config-file = ?"~/.dotfiles/ghostty/config"'
linux_include='config-file = ?"~/.dotfiles/ghostty/linux.config"'

mkdir -p "$(dirname "$ghostty_config")"
touch "$ghostty_config"

tmp="$(mktemp "${ghostty_config}.tmp.XXXXXX")"
trap 'rm -f "$tmp"' EXIT

# Personal config must be loaded last so it can override Omarchy defaults,
# followed by the Linux point-size overrides (see linux.config).
awk -v marker="$dotfiles_marker" -v include_line="$dotfiles_include" -v linux_line="$linux_include" '
  $0 != marker && $0 != include_line && $0 != linux_line { lines[++count] = $0 }
  END {
    while (count > 0 && lines[count] == "") count--
    for (i = 1; i <= count; i++) print lines[i]
    if (count > 0) print ""
    print marker
    print include_line
    print linux_line
  }
' "$ghostty_config" > "$tmp"

if cmp -s "$tmp" "$ghostty_config"; then
  echo "Ghostty dotfiles config already included last"
  exit 0
fi

chmod --reference="$ghostty_config" "$tmp"
mv "$tmp" "$ghostty_config"
trap - EXIT
echo "Included dotfiles config from $ghostty_config"
