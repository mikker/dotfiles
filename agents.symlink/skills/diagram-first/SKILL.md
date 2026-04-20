---
name: diagram-first
description: Diagram-first explanations using ASCII visualizations (sequence diagrams, flowcharts, component maps) to explain code, systems, request/response flows, pipelines, concurrency, and comparisons. Use when the user asks to "draw an ASCII diagram", "show the flow/logic", "visualize the architecture", "explain how it works", or when a diagram would reduce ambiguity in a technical explanation.
---

# Diagram First

## Overview

Answer questions with a short ASCII diagram first, then a concise explanation.
Prefer visual structure over prose when describing flows, architecture, or logic.

## Default Output Pattern

1. **Diagram first** (in a code block for alignment).
2. **Legend** (1–3 bullets, only if needed).
3. **Explanation** (map diagram nodes/edges to the user’s question; cite key files/functions if relevant).
4. **Next check** (optional: one quick validation step or a clarifying question).

## Choose a Diagram Type

Use the smallest diagram that answers the question:

- **Flowchart**: branching logic, error paths, validation, “what happens when…”.
- **Sequence diagram**: request/response, streaming, callbacks, cancellation, distributed coordination.
- **Component diagram**: modules/services and their responsibilities.
- **Pipeline diagram**: stage-by-stage compute (tokenization → forward → sampling → decode), incl. distributed ranks.
- **State machine**: lifecycle of a request, streaming states, tool-call modes.
- **Side-by-side**: comparisons (“left vs right”, “old vs new”, “A vs B”) using two columns.

## Diagram Templates

### Sequence (streaming / HTTP)

```text
Client -> HTTP Handler (rank0) -> (broadcast request) -> All Ranks: generate loop
Client <- HTTP Handler (rank0) <- (stream tokens/chunks) <- rank0 only
```

### Flowchart (validation / routing)

```text
request
  |
  v
parse -> validate -> route -> run -> shape response -> send
                 \-> error -> JSON error
```

### Component map (codebase)

```text
api/ (HTTP schemas + shaping) -> model_provider (load) -> tool_fixes (normalize) -> mlx_lm (generate)
```

### Side-by-side compare

```text
LEFT (A)                        RIGHT (B)
---------                       ---------
...                             ...
```

## Practical Rules

- Keep diagrams tight: ~10–30 lines; add a second diagram only if it reduces confusion.
- Include the **happy path**; add the most important failure/cancel path if relevant.
- Use stable labels (same node name = same thing) and avoid vague boxes (“stuff happens”).
- If you need to assume something, label it clearly in-diagram (e.g., “(assumption)”) and ask a clarifying question.
- Don’t leak secrets/PII in diagrams unless the user already provided it and asked to include it.
