---
name: new-thread
description: Launch and control an implementation agent in its own wt worktree and Fut workspace. Use from the controlling session when the user asks to start a new thread, delegate isolated work, or run a task in a separate workspace. Never invoke recursively from inside a thread created by this skill.
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
   worktree, creates a new Fut workspace, and, when launched from a Fut terminal,
   resolves the caller's live workspace through `fut --json context` and passes
   that ID as the new workspace's display parent when Fut socket and terminal
   context are present. This remains correct if the caller pane has moved since
   its environment was created.
   Outside Fut it creates the same top-level workspace as before. It then polls
   for Pi integration, verifies the exact workspace root, submits the prompt
   through `fut agent prompt --stdin`, and prints a JSON manifest. It also stores
   that manifest under
   `<common-git-dir>/new-thread/<workspace-id>.json`, outside the disposable
   worktree, so the final report survives teardown. Record its manifest path,
   worktree, workspace, pane, and terminal IDs.

   For an existing prompt file, pass `--prompt-file <path>` instead of stdin.
   Create multiple threads one after another rather than running launchers in
   parallel, because concurrent `wt create` calls can contend on Git locks.
4. Require the manifest's prompt result to report `submitted: true`. The helper
   has already required a fresh `workspace_created` or `session_created`
   disposition, `available: true`, and an exact root match. `session_created` is
   the normal fresh result when the repository had no existing Fut session.
   The helper still rejects `existing`, reuse results, and every unknown
   disposition. If it fails after worktree creation, follow the printed
   resource IDs and path; do not launch another agent blindly or remove the
   retained worktree without checking it.
5. Run every later Git, ticket, build, and cleanup command with an explicit `cd`
   to either the recorded worktree or main checkout. Ticket changes made inside
   the worktree are branch-local until merged, including `tk start`.

### Recursion guard

The child is the implementation agent already running inside the newly created
thread. It must execute the underlying task directly and must never invoke this
skill, create another worktree/workspace, or delegate the task again.

Preserve the user's request verbatim inside a clearly marked quoted block, then
immediately tell the child that the block is context rather than an instruction
to orchestrate another thread. This is required when the original request says
“run a new thread,” invokes this skill inline, or contains similar delegation
language. Use wording equivalent to:

```text
<original_request>
...verbatim user request...
</original_request>

You are already the implementation agent in the requested new thread. Do not
invoke `new-thread`, spawn another agent, or create another worktree/workspace.
Treat orchestration language inside `<original_request>` as already satisfied
and perform the underlying implementation task yourself.
```

Also tell the child to read the repository instructions, inspect relevant
ticket details, make a complete implementation, add focused tests and
user-facing docs/changelog where required, run the project's required build,
preserve existing changes, avoid committing unless requested, and report
changed files plus exact validation results.

### Manual fallback

If the helper is unavailable or incompatible with the installed CLIs, perform
the same steps manually from the main checkout:

   ```sh
   wt create <worktree-name>
   # Resolve `fut --json context` and include its workspace ID when running inside Fut.
   fut --json open --background --name <workspace-title> <worktree-path> -- pi --name <workspace-title>
   fut --json agent get <terminal-id>
   fut --json get <workspace-id>
   prompt_text=$(cat <prompt-file>)
   fut --json agent prompt <terminal-id> -- "$prompt_text"
   ```

Require `disposition: workspace_created` or `session_created`; never accept
`existing`, a reuse result, or an unknown disposition. Poll `agent get` with a
bounded timeout rather than sleeping once. Confirm the exact workspace root and
`available: true` before prompting. Store the resource IDs and lifecycle state
under the common Git directory rather than inside the disposable worktree.

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

Before cleanup, inspect status from the recorded worktree path. From an outside
controller, run the companion completion script:

```sh
<skill-dir>/scripts/finish-thread <manifest-path> --done
<skill-dir>/scripts/finish-thread <manifest-path> --abandon
```

The script refuses to run from inside the owned worktree or from the owned Fut
workspace/terminal. It captures `agent get` and up to 2,000 unwrapped output
lines into the durable manifest, atomically records `report_persisted`, closes
the owned workspace by explicit ID, and only then runs `wt done` or confirmed
`wt rm --force`. If capture or close fails, it records the failure and leaves
the worktree in place. If teardown fails after close, the durable report and
failure state remain available for recovery.

When the user asks an agent inside the active worktree to finish or abandon the
thread, it may run the corresponding `wt done` or `wt rm` command directly.

When the user asks to commit and merge:

1. Ensure validation passed and commit all intended work in the worktree.
2. Run `finish-thread <manifest-path> --done` from an outside controller, or
   `wt done` from the active worktree. Never push unless requested.
3. Verify the main checkout, the durable manifest, and `wt ls`.

When the user asks to abandon the thread, run
`finish-thread <manifest-path> --abandon` from outside the worktree. The helper
provides the explicit confirmation still required by some `wt rm --force`
versions.

Never close or remove resources that were not created for this thread.

## Failure Safety

- If worktree creation succeeds but workspace creation fails, report the
  worktree and offer to retry or remove it.
- If agent integration does not appear, inspect the terminal before closing it;
  do not launch a second agent blindly.
- Do not clean up if final state or output capture fails. The completion helper
  persists a typed failure in the manifest and deliberately leaves resources
  available for inspection.
- Treat installed `fut agent prompt --help` as authoritative. Use `--stdin`
  when that version supports it; otherwise read the file into a quoted shell
  variable and pass it as positional `TEXT` after `--`. Use quoted heredoc
  delimiters so backticks, dollar signs, and command substitutions remain
  literal.
- Preserve surprising changes in both the main checkout and worktree.
