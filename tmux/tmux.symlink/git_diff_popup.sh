#!/bin/bash
set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not inside a git repository."
  echo
  read -r -n 1 -p "Press any key to close..." _
  echo
  exit 0
fi

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

index_path="$(git rev-parse --git-path index)"
tmp_index="$(mktemp "${index_path}.tmux-diff.XXXXXX")"
trap 'rm -f "$tmp_index"' EXIT

export GIT_INDEX_FILE="$tmp_index"

if [[ -f "$index_path" ]]; then
  cp "$index_path" "$tmp_index"
else
  rm -f "$tmp_index"
  git read-tree HEAD 2>/dev/null || true
fi

untracked=()
while IFS= read -r -d '' file; do
  untracked+=("$file")
done < <(git ls-files --others --exclude-standard -z)

if ((${#untracked[@]})); then
  git add --intent-to-add -- "${untracked[@]}"
fi

status=0
git diff HEAD || status=$?

echo
echo "Press any key to close..."
read -r -n 1 _
exit "$status"
