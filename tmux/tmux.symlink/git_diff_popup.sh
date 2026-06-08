#!/bin/bash
set -euo pipefail

against_base=false
if [[ "${1:-}" == "--base" ]]; then
  against_base=true
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not inside a git repository."
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

target=HEAD
if $against_base; then
  for ref in main master; do
    if git rev-parse --verify --quiet "$ref" >/dev/null; then
      target="$(git merge-base HEAD "$ref")"
      break
    fi
  done
fi

# Always run our own pager. Git/less defaults often include -F/--quit-if-one-screen,
# which makes short diffs close the tmux popup immediately. Disabling -F/-E makes
# the popup consistently require exactly one q press to dismiss.
git --no-pager diff "$target" |
  ~/.dotfiles/bin/git-delta --paging=always --pager='less -R -+F -+E'
