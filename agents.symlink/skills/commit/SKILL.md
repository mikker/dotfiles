---
name: commit
description: Write git commit messages. Use when asked to commit, write a commit message, or stage and commit changes.
---

# Git Commit Messages

Write commit messages following these rules:

1. **Subject line**: Start with a capitalized imperative verb. ~50 chars max.
2. **Blank line** between subject and body (if body exists).
3. **Imperative mood**: "Add", "Fix", "Update" — not "Added", "Fixed", "Updated".
4. **Body** (optional): Explain *what* and *why*, not *how*. Wrap at 72 chars.
5. **Bullet points** for multiple changes in the body.
6. **Reference issues/PRs** when relevant: `Fix incorrect total (#4342)`.

## Examples

```
Add user authentication module
```

```
Refactor authentication logic

Extract auth logic into a separate module to improve performance
and reduce code duplication. Makes future enhancements easier.
```

```
Improve error handling in payment processing

- Add validation for payment input fields
- Handle API errors with retry mechanism
- Log detailed error messages for debugging
```

```
Fix incorrect total calculation (#4342)

Correct the calculation logic for order totals, ensuring
taxes and discounts are applied.
```
