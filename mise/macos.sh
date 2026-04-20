#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/script/lib.sh"

link_path "mise/config.toml" "$HOME/.config/mise/config.toml"
