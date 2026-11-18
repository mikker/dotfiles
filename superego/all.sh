#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/script/lib.sh"

# Superego's user profiles live in github.com/mikker/superego-profiles, checked out to ~/dev/superego-profiles.
repo="$HOME/dev/superego-profiles"
[ -d "$repo" ] || git clone https://github.com/mikker/superego-profiles.git "$repo"

# Each linked on its own, so a machine can keep profiles of its own beside them.
for profile in "$repo"/profiles/*/; do
  name="$(basename "$profile")"
  link_path "${profile%/}" "$HOME/.superego/profiles/$name"
done

# Their node_modules link to this machine's Superego types; made once Superego is installed.
if command_exists superego; then
  superego profile types --user || echo "superego profile types --user failed: run it again once Superego is set up" >&2
fi
