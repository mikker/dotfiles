#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/script/lib.sh"

if command_exists git-lfs; then
  git lfs install --skip-repo
fi

link_path "git/linux.gitconfig" "$HOME/.gitconfig.platform"
