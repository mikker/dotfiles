#!/bin/bash
set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not inside a git repository."
  echo
  read -r -n 1 -p "Press any key to close..." _
  echo
  exit 0
fi

files=(.)
while IFS= read -r -d '' file; do
  files+=("$file")
done < <(git ls-files --others --exclude-standard -z)

exec git diff HEAD -- "${files[@]}"
