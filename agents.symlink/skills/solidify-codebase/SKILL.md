---
name: solidify-codebase
description: Deep investigation and solidification pass on an existing codebase. Use when asked to audit, simplify, or future-proof a system; perform a deep cleanup/refactor pass; identify high-impact improvement opportunities; or present a vetted change list before implementing selected items.
---

# Solidify Codebase

## Overview

Perform a two-phase codebase solidification pass: investigate and map the system first, then implement only the user-selected improvements with a bias toward deletion and clarity.

## Workflow

### Phase 1 — Investigation (no code changes)

1. Build a mental model:
   - Identify entry points, core domains, data flows, and invariants.
   - Note ownership boundaries (modules, services, layers).
   - Trace 2–3 critical flows end-to-end.
2. Surface 5–10 high-impact opportunities.
3. For each opportunity, provide:
   - What to change (1–2 sentences).
   - Why it improves simplicity, clarity, or robustness.
   - Estimated risk: low / medium / high.
4. Present the list and wait for selection before editing code.

Use this output template:

1. [Title] — What: ... Why: ... Risk: ...

### Phase 2 — Targeted Improvements (after selection)

1. Apply changes incrementally, one logical change at a time.
2. Prefer deletion over addition; avoid new abstractions unless they clearly reduce complexity.
3. Preserve behavior; run build/tests after each logical change.
4. Update or extend tests only when it meaningfully increases confidence.
5. Keep diffs small and explain tradeoffs or residual risks.
6. Follow repository-specific instructions for workflow, formatting, and testing.
