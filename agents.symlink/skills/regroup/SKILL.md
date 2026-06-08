---
name: regroup
description: Rebase a feature worktree on main/master, resolve conflicts, ff-only merge into the trunk worktree, then rebase feature on updated trunk.
---

# Regroup

`main`/`master` here means the trunk git branch.

Run from a non-trunk worktree.

## Flow

```bash
feature_dir=$(pwd)
feature_branch=$(git branch --show-current)
trunk_branch=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD | sed 's#^origin/##')
if [ -z "$trunk_branch" ]; then
  if git show-ref --verify --quiet refs/heads/main || git show-ref --verify --quiet refs/remotes/origin/main; then
    trunk_branch=main
  elif git show-ref --verify --quiet refs/heads/master || git show-ref --verify --quiet refs/remotes/origin/master; then
    trunk_branch=master
  fi
fi
trunk_dir=$(git worktree list --porcelain | awk -v branch="refs/heads/$trunk_branch" '$1=="worktree"{wt=$2} $1=="branch"&&$2==branch{print wt; exit}')
test -n "$feature_branch" && test -n "$trunk_branch" && test "$feature_branch" != "$trunk_branch" && test -n "$trunk_dir"

git fetch --all --prune
git rebase "$trunk_branch"
# resolve conflicts: inspect, edit, git add, git rebase --continue

git -C "$trunk_dir" merge --ff-only "$feature_branch"
git -C "$feature_dir" rebase "$trunk_branch"

git -C "$feature_dir" status --short
git -C "$trunk_dir" status --short
```

## Guardrails

- Stop on unexpected dirty state.
- Ask for semantic conflict choices.
- Never non-ff merge into trunk (`main` or `master`).
- Never push/force-push unless asked.
- If no trunk worktree exists, ask for path.
