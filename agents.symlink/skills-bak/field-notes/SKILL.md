---
name: field-notes
description: User-owned external project notes in ~/.field_notes. Use when the user asks to check, search, read, save, append, update, or consult field notes; phrases include "check field notes", "look in field notes", "save to field notes", "what do field notes say", "what's next", progress notes, planning notes, external docs, cross-project memory, or docs that should live outside a repository.
---

# Field Notes

Field Notes are user-owned markdown notes outside any repo, stored at:

```txt
~/.field_notes
```

They are for cross-project memory: planning, progress, decisions, prompts, TODOs, and external docs that should not live in project repos or `~/.pi`.

## Rules

- Only consult Field Notes when explicitly requested or clearly implied by the user.
- Cite note paths when using them: `~/.field_notes/<file>`.
- Prefer project/domain-prefixed filenames: `<project-or-domain>-<topic>.md`.
- Flat files are encouraged; folders are allowed.
- Markdown is the default format.
- Do not store secrets.
- Do not overwrite notes unless the user asks. Prefer append/update by section.

## Helper CLI

Use the bundled helper:

```bash
~/.agents/skills/field-notes/scripts/field-notes help
```

Common commands:

```bash
~/.agents/skills/field-notes/scripts/field-notes init
~/.agents/skills/field-notes/scripts/field-notes list
~/.agents/skills/field-notes/scripts/field-notes search "sample-app progress"
~/.agents/skills/field-notes/scripts/field-notes read sample-app-progress.md
~/.agents/skills/field-notes/scripts/field-notes new sample-app-progress --title "Sample App Progress"
~/.agents/skills/field-notes/scripts/field-notes append sample-app-progress.md "- Finished X"
```

The directory can be overridden for one command with:

```bash
FIELD_NOTES_DIR=/path/to/notes ~/.agents/skills/field-notes/scripts/field-notes list
```

## Search workflow

When asked to check Field Notes:

1. Run `field-notes init` if `~/.field_notes` does not exist.
2. Search filenames and content with the user/project terms:
   ```bash
   ~/.agents/skills/field-notes/scripts/field-notes search "<query>"
   ```
3. Read the best matching notes:
   ```bash
   ~/.agents/skills/field-notes/scripts/field-notes read <relative-path>
   ```
4. Answer using only relevant excerpts and cite files.

If the query is vague, infer the current project name from cwd and include it in the search. Example from `/Users/mikker/dev/acme/sample-app`: search `sample-app progress next tasks`.

## Save/update workflow

When asked to save to Field Notes:

1. Pick a filename using `<project-or-domain>-<topic>.md` unless the user specifies one.
2. Create the note if missing.
3. Append dated content unless the user asks to rewrite/replace.
4. Keep notes concise and scannable.

Good headings:

```md
# Sample App Progress

## 2026-06-19

- Done: ...
- Next: ...
- Open questions: ...
```
