---
name: data-structure-review
description: Review recent spike or implementation work for data structures and organizing models that would materially simplify the code. Use after exploratory work, when asked to reconsider the design, or when scattered state, repeated branches, unclear ownership, invalid intermediate states, fragile ordering, or duplicated transformations appear.
---

# Data Structure Review

Review the work just completed for cleanup opportunities where a better data structure or organizing model would make the code simpler, safer, or easier to extend.

Consider whether accidental complexity could be reduced by:

- A state machine instead of scattered booleans, phases, or lifecycle checks.
- A typed object or model instead of loose parameters or repeated shape assumptions.
- A map, registry, lookup table, or discriminated union instead of branching spread across files.
- A reducer or command/event model instead of ad hoc state mutations.
- A small module boundary that gathers repeated behavior, ownership, or invariants.
- A queue, cache, index, graph/tree, or normalized collection where the access pattern calls for it.

Do not force an abstraction. Prefer boring code when the current shape is clear, local, and unlikely to grow. Reject abstractions that add indirection without removing branches, duplicated rules, invalid states, or lifecycle risk.

## Evaluate

1. Complexity revealed by the work: repeated conditionals, mirrored state, unclear ownership, invalid intermediate states, awkward data flow, fragile ordering, or duplicated transformations.
2. Whether a data structure or organizing model would encode the domain more directly.
3. The smallest useful cleanup that improves the code without changing behavior.
4. Risk: files touched, behavior affected, test impact, and whether the cleanup should wait.

If a clear, low-risk cleanup fits the current task scope, implement it and run relevant checks. If it is larger, speculative, or distracting, do not implement it; return a concise recommendation instead.

## Return

1. **Verdict:** `implement`, `recommend`, or `skip`.
2. **Opportunity:** Concrete data structure or organizing model, or `none`.
3. **Why:** Complexity removed and invariants clarified.
4. **Scope:** Smallest credible change.
5. **Validation:** Checks run or needed.
