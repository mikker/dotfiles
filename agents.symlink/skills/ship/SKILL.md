---
name: ship
description: Commit all current work in logical chunks, synchronize it with origin/main or origin/master, run the full test suite, push to trunk, and update relevant tracker issues. Use when the user asks to ship, publish, or push all changes.
---

# Ship

Ship the current branch's committed and uncommitted work to the trunk branch on
`origin`. This skill is explicit authorization to create commits and push them,
but never to force-push.

## Workflow

1. **Inspect the repository**
   - Read repository instructions and determine the full-suite test command.
   - Inspect the current branch, `git status`, staged and unstaged diffs, and
     untracked files.
   - Determine trunk from `origin/HEAD`, falling back to `main`, then `master`.
     If the target is still ambiguous, ask the user.
   - Do not include ignored files, secrets, credentials, or obvious generated
     artifacts merely because they exist locally.

2. **Commit all uncommitted work**
   - Include staged, unstaged, and appropriate untracked changes.
   - Split the work into the smallest sensible logical commits. Keep tests with
     the behavior they verify and avoid mixing independent concerns.
   - Review each staged diff before committing. Follow the project's commit
     conventions; otherwise use concise, imperative commit messages.
   - Do not amend or rewrite existing commits unless synchronization requires a
     rebase. Do not bypass commit hooks.

3. **Synchronize with trunk**
   - Fetch `origin`, then rebase the current branch onto `origin/<trunk>` when
     the remote branch contains commits not already in `HEAD`.
   - Resolve straightforward, mechanical conflicts carefully and continue the
     rebase. Never resolve conflicts wholesale with `ours` or `theirs`.
   - A substantive conflict is one where both sides changed behavior, intent is
     ambiguous, data could be lost, or the resolution requires a product or
     design choice. For any substantive conflict, explain the competing changes
     and ask the user how to proceed before editing the resolution. Leave the
     rebase paused while waiting.

4. **Run the full test suite**
   - Run the project's complete test suite after the final commit/rebase and
     before pushing. Also run required lint, type-check, or build commands when
     the project treats them as part of its standard verification.
   - Fix failures caused by the work being shipped, then rerun verification.
   - A failure may be ignored only when there is concrete evidence that the same
     failure occurs on the exact upstream trunk commit, ideally verified in a
     temporary clean worktree. Record that evidence in the final report. Any
     other failure blocks the push.

5. **Push to trunk**
   - Push with a normal fast-forward update, for example:
     `git push origin HEAD:<trunk>`.
   - Never force-push or use `--force-with-lease`.
   - If the push is rejected because upstream advanced, fetch, rebase onto the
     updated `origin/<trunk>`, apply the conflict rules above, rerun the full test
     suite, and retry the push.
   - If branch protection, authentication, or another non-fast-forward reason
     prevents the push, report it rather than bypassing the protection.

6. **Update issue tracking**
   - If the project uses an issue tracker, identify relevant issues from the
     branch, commits, repository metadata, and the changes themselves. Do not
     guess an issue association.
   - After a successful push, close issues fully resolved by the shipped work;
     otherwise add a concise progress update with the pushed commit when useful.
   - If no tracker or relevant issue is evident, skip this step.

7. **Report**
   - Summarize commits created, the pushed branch and commit, verification
     results (including any proven upstream failures), and issue updates.

## Guardrails

- Do not discard local work.
- Do not push until every intended local change is committed and accounted for.
- Do not push with unresolved or unexplained test failures.
- Ask only for ambiguous target selection or substantive conflict decisions;
  routine commit, rebase, test, and push steps are already authorized.
