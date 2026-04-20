---
name: nitro-kit-components
description: Build or refactor Nitro Kit-style UI components, helpers, and Stimulus behaviors in Rails apps. Use when working in the Nitro Kit repo or when creating app-specific components that should follow Nitro Kit conventions (Phlex + Tailwind + minimal Stimulus), or when reviewing for Nitro Kit style guide compliance.
---

# Nitro Kit Components

## Overview

Use this skill to build or modify Nitro Kit-style components and helpers. Always read `nitro_kit/STYLE_GUIDE.md` in the repo first and apply those conventions. If it is not available, read `references/style_guide.md` bundled with this skill.

## Workflow

1) Read `nitro_kit/STYLE_GUIDE.md` if available; otherwise read `references/style_guide.md`. Follow its rules (component anatomy, builder pattern, attribute merging, accessibility, and form layout defaults).
2) Decide scope:
   - Nitro Kit core: components under `app/components/nitro_kit/` + helper + schema + tests/examples.
   - App-specific UI: create under `app/components/ui/` (or your own namespace) and keep Nitro Kit core untouched.
3) Implement using Phlex + Tailwind utilities, minimal JS (Stimulus only if needed).
4) If working on forms, default to `fieldset` + `group` layout unless you intentionally want a custom layout.
5) Update tests/examples when changes affect rendered output or component APIs.

## Notes

- Do not duplicate the style guide inside this skill. The source of truth is `nitro_kit/STYLE_GUIDE.md`.
- If you need new or clarified conventions, update the style guide first, then implement.

## Update workflow

When `nitro_kit/STYLE_GUIDE.md` changes, refresh the skill bundle:

1) Copy the guide into `references/style_guide.md`.
2) Re-run validation and package the skill.
