---
name: new-thread
description: Launch and control an implementation agent in its own wt worktree and Fut workspace. Use when the user asks to start a new thread, delegate isolated work, or run a task in a separate workspace.
---

# New Thread

Run a free-form task in a dedicated Git worktree, Fut workspace, and integrated
Pi agent. The worktree path is the workspace root; do not put the agent in a new
pane or tab of the caller's workspace.

## Launch

1. Read the installed `wt` and `fut` help needed for the commands below. Treat
   those CLIs as authoritative.
2. Derive two concise, distinctive names without asking when the request makes
   them clear:
   - **Worktree name:** a short branch-compatible identifier. If the request
     names a ticket, inspect it first and prefer its ID or a compact title slug.
   - **Workspace title:** a very short human-readable label, ideally one to
     three words, that is easy to distinguish in Fut's navigator. It may be
     shorter and friendlier than the worktree name.
3. Build a complete child prompt in a literal heredoc and launch the thread with
   the companion script:

   ```sh
   <skill-dir>/scripts/launch-thread <worktree-name> --workspace-name <workspace-title> <<'PROMPT'
   <complete child prompt>
   PROMPT
   ```

   The script requires `git`, `wt`, `fut`, `jq`, and `pi`. It creates the
   worktree, creates a new Fut workspace, polls for Pi integration, verifies the
   exact workspace root, submits the prompt through `fut agent prompt --stdin`,
   and prints a JSON manifest. It also stores that manifest as
   `new-thread.json` in the worktree's private Git directory. Record its
   worktree, workspace, pane, and terminal IDs.

   For an existing prompt file, pass `--prompt-file <path>` instead of stdin.
   Create multiple threads one after another rather than running launchers in
   parallel, because concurrent `wt create` calls can contend on Git locks.
4. Require the manifest's prompt result to report `submitted: true`. The helper
   has already required `disposition: workspace_created`, `available: true`, and
   an exact root match. If it fails after worktree creation, follow the printed
   resource IDs and path; do not launch another agent blindly or remove the
   retained worktree without checking it.
5. Run every later Git, ticket, build, and cleanup command with an explicit `cd`
   to either the recorded worktree or main checkout. Ticket changes made inside
   the worktree are branch-local until merged, including `tk start`.

The child prompt must preserve the user's request verbatim. Also tell the child
to read the repository instructions, inspect relevant ticket details, make a
complete implementation, add focused tests and user-facing docs/changelog where
required, run the project's required build, preserve existing changes, avoid
committing unless requested, and report changed files plus exact validation
results.

### Manual fallback

If the helper is unavailable or incompatible with the installed CLIs, perform
the same steps manually from the main checkout:

   ```sh
   wt create <worktree-name>
   fut --json open --background --name <workspace-title> <worktree-path> -- pi --name <workspace-title>
   fut --json agent get <terminal-id>
   fut --json get <workspace-id>
   prompt_text=$(cat <prompt-file>)
   fut --json agent prompt <terminal-id> -- "$prompt_text"
   ```

Require `disposition: workspace_created`; never accept `existing`. Poll
`agent get` with a bounded timeout rather than sleeping once. Confirm the exact
workspace root and `available: true` before prompting.

Do not wait for completion by default. Report the workspace name, worktree path,
and launched task so the user can switch to it immediately.

## Control

Always target the recorded terminal ID; never rely on whichever workspace or
pane currently has focus.

```sh
fut --json agent get <terminal-id>
fut --json agent read <terminal-id> --source recent-unwrapped --lines 200
fut --json agent wait <terminal-id> --timeout 10m
follow_up=$(cat <follow-up-file>)
fut --json agent prompt --wait --timeout 10m <terminal-id> -- "$follow_up"
```

- Use `agent wait` for work already underway.
- Use `agent prompt --wait` for a fresh follow-up and inspect the returned
  lifecycle state. A `blocked` state is a result to surface, not a reason to
  retry blindly.
- Read the agent's output and inspect the worktree diff before accepting the
  result. Send review fixes back through `agent prompt` when appropriate.
- Keep the workspace open until the user asks to finish or abandon it.

## Finish

Before cleanup, collect the final agent output and inspect status from the
worktree path.

When the user asks to commit and merge:

1. Ensure validation passed and commit all intended work in the worktree.
2. Close the owned Fut workspace by explicit ID so no process remains rooted in
   the worktree:

   ```sh
   fut --json workspace close <workspace-id>
   ```
3. Run `wt done` from the worktree path. Never push unless requested.
4. Verify the main checkout and `wt ls`.

When the user asks to abandon the thread, close the owned Fut workspace first,
then remove only the owned worktree. `wt rm --force` still asks for confirmation
in some versions, so provide explicit stdin for intentional noninteractive
cleanup:

```sh
printf 'y\n' | wt rm <name> --force
```

Never close or remove resources that were not created for this thread.

## Failure Safety

- If worktree creation succeeds but workspace creation fails, report the
  worktree and offer to retry or remove it.
- If agent integration does not appear, inspect the terminal before closing it;
  do not launch a second agent blindly.
- Treat installed `fut agent prompt --help` as authoritative. Use `--stdin`
  when that version supports it; otherwise read the file into a quoted shell
  variable and pass it as positional `TEXT` after `--`. Use quoted heredoc
  delimiters so backticks, dollar signs, and command substitutions remain
  literal.
- Preserve surprising changes in both the main checkout and worktree.
