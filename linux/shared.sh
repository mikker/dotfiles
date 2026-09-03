#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/script/lib.sh"

# Debian-family distributions rename these binaries to avoid package conflicts.
if ! command_exists bat && [[ -x /usr/bin/batcat ]]; then
  link_path "/usr/bin/batcat" "$HOME/.local/bin/bat"
fi
if ! command_exists fd && [[ -x /usr/bin/fdfind ]]; then
  link_path "/usr/bin/fdfind" "$HOME/.local/bin/fd"
fi

if command_exists git-lfs; then
  git lfs install --skip-repo
fi

link_path "git/linux.gitconfig" "$HOME/.gitconfig.platform"

if ! command_exists llm; then
  echo "Install llm"
  if command_exists uv; then
    uv tool install llm
  elif command_exists pipx; then
    pipx install llm
  else
    fail "uv or pipx is required to install llm"
  fi
fi
