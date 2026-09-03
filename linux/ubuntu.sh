#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/script/lib.sh"

packages=()
while IFS= read -r package; do
  [[ -n "$package" && "$package" != \#* ]] && packages+=("$package")
done < "$DOTFILES_ROOT/linux/apt-packages"

command_exists apt-get || fail "apt-get is required to install Ubuntu dependencies"
echo "Install Ubuntu dependencies"
sudo apt-get update
sudo apt-get install -y "${packages[@]}"
