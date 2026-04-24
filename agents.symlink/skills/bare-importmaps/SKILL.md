---
name: bare-importmaps
description: Enforce Bare-style builtin imports and package-local import maps for Holepunch, Pear, Autobonk, Bare runtime, and other dual-runtime JavaScript work. Use when editing code that may run under Bare or a repo that already uses package.json "imports" for bare polyfills. Prefer plain builtin specifiers like "fs", "path", "crypto", "url", "http", and "https" instead of "node:*", and update the nearest package.json import map and dependencies when a new builtin is introduced.
---

# Bare Importmaps

When working in a Bare, Pear, Holepunch, Autobonk, or dual-runtime JavaScript codebase:

- Prefer plain builtin specifiers:
  - `import fs from 'fs'`
  - `import path from 'path'`
  - `import { randomBytes } from 'crypto'`
- Do not introduce `node:*` imports.

## Rules

1. Check the nearest relevant `package.json`, not just the repo root.
   - Import maps are package-local.
   - If a subpackage runs independently, it needs its own `"imports"` entries and bare polyfill dependencies.

2. If code may run under Bare, make the import map match the builtin you use.
   - Example:
     - `"path": { "bare": "bare-path", "default": "path" }`
     - `"crypto": { "bare": "bare-crypto", "default": "crypto" }`
     - `"http": { "bare": "bare-https", "default": "http" }`
     - `"https": { "bare": "bare-https", "default": "https" }`

3. If you add a new mapped builtin, add the actual dependency too.
   - Examples:
     - `bare-path`
     - `bare-fs`
     - `bare-fs/promises` via `bare-fs`
     - `bare-crypto`
     - `bare-url`
     - `bare-os`
     - `bare-process`
     - `bare-events`
     - `bare-https`

4. Keep imports consistent across the codebase.
   - If a file or package already uses Bare import-map style, convert nearby `node:*` imports to the plain builtin form while you are there.

5. Validate after changes.
   - Re-scan for `node:` imports with `rg`.
   - Reinstall if `package.json` changed.
   - Run the relevant tests/build.

## Workflow

1. Search for `node:` imports in the affected package(s).
2. Replace them with plain builtin specifiers.
3. Inspect the nearest `package.json` for `"imports"`.
4. Add any missing bare polyfill mappings and dependencies.
5. Re-scan for `node:` imports.
6. Run package-specific verification.

## Notes

- Root package import maps do not cover nested published packages.
- Node-only scripts can usually still use plain builtin specifiers safely; prefer consistency unless the repo has a strong contrary convention.
- When unsure whether a module runs under Bare, bias toward keeping the package import-map-ready if the surrounding package already does.
