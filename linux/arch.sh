#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/script/lib.sh"

repo_packages=()
missing_repo_packages=()
aur_packages=()

while IFS= read -r package; do
  [[ -n "$package" && "$package" != \#* ]] && repo_packages+=("$package")
done < "$DOTFILES_ROOT/linux/pacman-packages"

while IFS= read -r package; do
  [[ -n "$package" && "$package" != \#* ]] && aur_packages+=("$package")
done < "$DOTFILES_ROOT/linux/aur-packages"

command_exists pacman || fail "pacman is required to install Arch Linux dependencies"
for package in "${repo_packages[@]}"; do
  # pacman -Q accepts packages provided by another package (mise-bin provides mise).
  pacman -Q "$package" &>/dev/null || missing_repo_packages+=("$package")
done

echo "Install Arch Linux dependencies"
if command_exists omarchy; then
  if (( ${#missing_repo_packages[@]} > 0 )); then
    omarchy pkg add "${missing_repo_packages[@]}"
  fi
  omarchy pkg aur add "${aur_packages[@]}"
else
  if (( ${#missing_repo_packages[@]} > 0 )); then
    sudo pacman --needed --sync "${missing_repo_packages[@]}"
  fi
  if (( ${#aur_packages[@]} > 0 )); then
    command_exists yay || fail "yay is required to install AUR dependencies: ${aur_packages[*]}"
    yay --needed --sync "${aur_packages[@]}"
  fi
fi
