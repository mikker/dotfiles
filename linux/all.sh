#!/usr/bin/env bash
set -euo pipefail

if command -v mise >/dev/null 2>&1; then
  echo "Install Mise tools"
  MISE_CONFIG_FILE="$DOTFILES_ROOT/mise/config.toml" mise install
fi

if ! command -v llm >/dev/null 2>&1; then
  echo "Install llm"
  uv tool install llm
fi
