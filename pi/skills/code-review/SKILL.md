---
name: code-review
description: Open and drive Pi's HTML Super Review UI for uncommitted changes or git ranges. Use when the user asks for super-review, review current changes, review against master/origin, or read comments from the review UI.
---

# Super Review

Use the `review_*` extension tools.

## Start

1. Call `review_start`.
   - Default: `{ "target": "uncommitted" }` (all uncommitted changes, including staged, unstaged, and untracked files)
   - For staged-only: `{ "target": "staged" }`
   - For unstaged tracked-only: `{ "target": "working" }`
   - For prompts like “against master/origin”: pass `{ "target": "against master" }` or `{ "target": "against origin" }`.
2. Immediately call `review_diff_snapshot`.
3. If you update the summary manually, use `review_update_summary` while the browser review stays open.

Summary style:
- Format:
  - `# [title]`
  - `> [tldr]`
  - `[stat line]`
  - summary body
- Summary tells a compact outside-in story: behavior/API outcome → implementation → tests.
- Generally cover all changed areas/files.
- Include small diff snippets or file-path bullets where useful so the summary carries the actual changes.
- Code snippets must be complete unified snippets in ```diff fences copied from the diff; the UI renders them with the same diff viewer as the full diff, not as markdown code blocks.
- Add only context the diff needs; avoid exhaustive line-by-line narration.
- Mermaid only for structural/control-flow changes that benefit from it.

## Comments

When the user asks what reviewers said, call `review_get_comments` and respond with actionable bullets grouped by file.

When the user asks to resolve review comments, call `review_resolve_comments` with either specific `ids` or `{ "all": true }`.

## Notes

- The review UI stores comments at `.pi/code-review-comments.json` in the repo.
- The UI auto-refreshes as the selected diff changes.
- Prefer `uncommitted` unless the user names a target.
