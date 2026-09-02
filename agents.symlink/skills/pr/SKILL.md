---
name: pr
description: Create and push pull requests. Use when the user uses “PR” as a verb or says “create a PR,” “push a PR,” or similar.
---

# PR

Read the [commit skill](../commit/SKILL.md) for guidance on describing changes and writing commits.

## Flow

1. Inspect repository instructions, status, diff, branch, and trunk.
2. Verify the change. Commit only intended work, then push the branch.
3. Create or update the PR with the format below.

## Format

**Title:** Imperative change description.

**Description:**

```markdown
<One imperative sentence.>

## TL;DR
<Brief summary.>

## Problem
<If applicable, one brief sentence covering the issue.>

## Desired outcome
<What we want.>

## Solution
<How we achieve it.>

## Context for agents
<Optional follow-up context, decisions, or discoveries.>
```

Keep the human-facing sections very short, plain, and product-level. Describe the resulting user experience, not implementation details. Mention the previous state only when it explains the problem, a decision, or other necessary context.

Omit **Problem** and **Context for agents** when unnecessary. Keep agent context minimal and clearly secondary to the human-facing description.
