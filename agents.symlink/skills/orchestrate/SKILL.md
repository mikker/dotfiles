---
name: orchestrate
description: Orchestrate implementation work through subagents while retaining responsibility for planning, integration, review, and validation.
argument-hint: "task description"
disable-model-invocation: true
---

# Orchestrate

Treat the user's free-form input after `/orchestrate` as the task description to implement. Act as the lead agent: own the plan, divide the work, preserve a coherent overall design, and remain accountable for the final result.

## Workflow

1. Understand the request and inspect the relevant context before delegating.
2. Form a concise implementation plan and split work only where responsibilities are clear and independent.
3. Delegate implementation to subagents. Give each one a self-contained assignment with the necessary context, constraints, ownership boundaries, and expected outcome.
4. Prefer smaller, faster models with lower reasoning effort for well-scoped implementation and review tasks when the current platform supports that choice. Reserve the strongest reasoning for orchestration, ambiguous decisions, integration, and final judgment.
5. Keep delegation proportional. Use one implementer for a focused change; use several only when work can proceed independently without overlapping ownership.
6. Integrate and inspect all contributions yourself. Resolve inconsistencies and ensure the pieces form the simplest coherent solution rather than a collection of local patches.
7. Ask an independent subagent to review the completed change for correctness, regressions, missing tests, and unnecessary complexity. Give the reviewer the result and requirements, not the implementation discussion.
8. Address substantive review findings, then run the appropriate validation. Do not rely on a subagent's claim that the work passes.
9. Report the finished result, validation performed, and any remaining risks or decisions.

## Principles

- The lead agent delegates execution, not responsibility.
- Keep the user-facing interaction unified; do not expose orchestration chatter unless it is useful.
- Avoid parallel work on the same files or tightly coupled behavior.
- Prefer clear ownership and small handoffs over elaborate agent hierarchies.
- Preserve existing project conventions and instructions across every assignment.
- Ask the user only when a genuine product decision or missing requirement prevents safe progress.
- If subagents or model selection are unavailable, follow the same plan, implementation, independent review, and validation stages directly.
