#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/script/lib.sh"

# Superego's user profiles, each linked on its own so a machine can keep profiles of its own beside them.
for profile in "$DOTFILES_ROOT"/superego/profiles/*/; do
  name="$(basename "$profile")"
  link_path "superego/profiles/$name" "$HOME/.superego/profiles/$name"
done

# Their node_modules link to this machine's Superego types; made once Superego is installed.
if command_exists superego; then
  superego profile types --user || echo "superego profile types --user failed: run it again once Superego is set up" >&2
fi
