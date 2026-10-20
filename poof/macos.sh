#!/usr/bin/env bash
set -euo pipefail

snippets="$HOME/Library/Application Support/Poof/snippets"

# Never replace existing snippets or pull over local edits.
if [[ -e "$snippets" || -L "$snippets" ]]; then
  echo "Poof snippets already exist at $snippets; leaving them unchanged"
else
  mkdir -p "$(dirname "$snippets")"
  git clone git@github.com:mikker/poof-snippets.git "$snippets"
fi
