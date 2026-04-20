---
name: reread-files-before-editing
description: Ensure files are re-read before editing to avoid overwriting user changes. Use when modifying existing files in the workspace.
---

# Re-read Files Before Editing

## Rule
Before editing any file, re-read it to ensure you are using the latest version.

## Scope
This is a one-time freshness check for the current operation. Do not assume previously read file contents are still valid if the user may have edited them.

## Rationale
The user may modify files outside your current context. Using stale content can overwrite those changes.

## Behavior
Before making an edit:
1. Fetch the latest version of the file.
2. Base your changes on that updated content.
