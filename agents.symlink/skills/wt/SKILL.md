---
name: wt
description: Manage Git worktrees with wt. Use to create, switch, list, remove, persist, merge, or ship worktrees.
---

Use `wt` to carry out the requested worktree operation:

- Create a worktree: `wt create <name>`. Derive a short,
  branch-compatible name from the task when possible; ask for one when the
  request has no naming context.
- Enter an existing worktree: `wt switch <name>`, or `wt switch` to pick one.
- List worktrees: `wt ls`.
- Remove a worktree without merging: `wt rm [<name>]`.
- Toggle persistence for the current worktree: `wt persist`.
- Merge the current worktree into local trunk: `wt done`.
- Sync with the remote, merge, and push trunk: `wt ship`.

For merge and ship requests, run the command and handle resolvable stops:

- If it stops on a rebase conflict: inspect, resolve, `git add`, `git rebase
  --continue`, then re-run the same `wt` command.
- If it stops on dirty state: commit or stash as appropriate, then re-run.

Never non-ff merge into trunk. Never push unless the user asked for that
(use `wt ship`, not a manual `git push`).

`wt --help` documents all commands.
