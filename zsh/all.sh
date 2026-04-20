#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/script/lib.sh"

current_shell="${SHELL:-}"

if command_exists dscl; then
  current_shell="$(dscl . -read "/Users/$USER" UserShell 2>/dev/null | awk '{print $2}')"
elif command_exists getent; then
  current_shell="$(getent passwd "$USER" | cut -d: -f7)"
fi

if [[ "$current_shell" == "/bin/zsh" ]]; then
  echo "Default shell already set to zsh"
  exit 0
fi

echo "Changing default shell to zsh"
chsh -s /bin/zsh
