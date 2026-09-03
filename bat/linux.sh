#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/script/lib.sh"

link_path "bat/themes" "$HOME/.config/bat/themes"
link_path "bat/config" "$HOME/.config/bat/config"

if command_exists bat; then
  bat cache --build
else
  echo "Skipping bat cache rebuild; bat is not installed"
fi
