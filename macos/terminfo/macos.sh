#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}/script/lib.sh"

path="$DOTFILES_ROOT/macos/terminfo"

find "$path" -name '*.terminfo' -print | sort | while IFS= read -r terminfo; do
  tic -x "$terminfo"
done
