---
name: proper-fix
description: Bias bug fixes and refactors toward root-cause solutions, simplification, and removal of workaround layers. Use when Codex is fixing a bug, flaky behavior, confusing edge case, or ugly conditional pileup and the obvious change looks like another patch on top of earlier patches, defensive code, or duplicated repair logic.
---

# Proper Fix

## Overview

Diagnose the underlying failure before editing. Prefer the smallest coherent fix at the source of truth over adding another compensating condition, fallback, or band-aid downstream.

## Work The Problem

Start by proving what is actually wrong.

- Reproduce the failure, trace the data flow, or read the full call chain before editing.
- Read the surrounding code, not just the failing line. Look for where the invariant should have been enforced earlier.
- Identify whether the current behavior comes from stale assumptions, split ownership, duplicated normalization, or state being repaired too late.
- Name the root cause in one sentence before choosing a fix. If you cannot do that, keep reading.

## Dig Deeper Signals

Pause and inspect the design one layer deeper when any of these show up:

- The fix wants a second special case beside an existing special case.
- The code already contains words like `workaround`, `temporary`, `legacy`, `hotfix`, or `compat`.
- Multiple places sanitize, default, or repair the same value.
- State becomes valid only after several follow-up mutations.
- Tests only pass when setup mirrors production accidents instead of clear rules.
- The proposed patch hides the bug instead of making invalid states impossible.

## Prefer These Fix Shapes

Reach for the earliest, simplest place that can make the bad state impossible.

- Tighten the data shape where it is created or parsed.
- Move validation or normalization to the boundary instead of repeating it at call sites.
- Collapse duplicate branches into one explicit rule.
- Replace repair logic with a single authoritative state transition.
- Rewrite a small confusing section if that is clearer than threading another exception through the system.
- Delete obsolete fallback logic when the source issue is fixed.

## Keep Scope Coherent

Do not turn "proper fix" into "rewrite the world."

- Prefer a local rewrite when it removes complexity inside the touched area.
- Stop expanding once the fix reaches unrelated subsystems with no direct evidence.
- If the real fix is too large for the task, make the smallest honest change and say clearly what compromise remains.
- Preserve intentional external behavior unless the user asks to change it.
- If you are choosing between a quick patch and a slightly deeper simplification, spend one more short investigation pass first.

## Report The Fix Clearly

When you answer or summarize the change:

- State the root cause directly.
- State why the chosen fix is earlier, simpler, or more authoritative than the obvious patch.
- Mention any workaround code you removed or any compromise you left in place.
