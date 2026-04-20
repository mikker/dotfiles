---
name: tailwind-modern
description: "Use when working on anything Tailwind or utility-class styling: writing class strings, reviewing Tailwind code, migrating Tailwind 3 to 4, editing CSS with Tailwind directives, changing design tokens, custom utilities, variants, config, plugins, Vite/PostCSS setup, safelists/sources, or fixing broken/old Tailwind syntax. Auto-trigger on requests mentioning Tailwind, utility classes, class strings, @theme, @utility, tailwind.config, design tokens, or Tailwind migration."
---

# Tailwind Modern

Write Tailwind as Tailwind v4-first by default.

Goal: always produce modern Tailwind syntax, config, and customization patterns. Avoid v3-era patterns unless the repo is clearly pinned to v3 and the task is intentionally legacy.

## Default stance

- Prefer Tailwind v4 patterns.
- Prefer CSS-first config over JavaScript config.
- Prefer design tokens in `@theme` over `tailwind.config.js` theme extension.
- Prefer `@utility` over old custom utility patterns.
- Prefer static, detectable class strings.
- Prefer utility classes in markup over custom CSS.
- Use arbitrary values sparingly; promote repeated values into `@theme`.
- If a repo is on v3, either:
  - keep changes compatible with v3 if asked for a narrow fix, or
  - propose/perform a clean v4 migration.

## Fast workflow

1. Detect Tailwind version from `package.json`, CSS entrypoints, PostCSS/Vite config, and existing syntax.
2. If v4 or mixed/unclear, write v4 syntax.
3. If touching theme/config/custom utilities, normalize toward v4 patterns in the touched area.
4. If you see v3 syntax while editing v4 code, fix it in the same pass when safe.
5. Keep changes simple. Don’t preserve obsolete config patterns without reason.

## Tailwind v4 defaults

### Imports
Use:

```css
@import "tailwindcss";
```

Not:

```css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

### Theme customization
Use CSS theme variables:

```css
@import "tailwindcss";

@theme {
  --font-display: "Satoshi", sans-serif;
  --color-brand-500: oklch(0.72 0.11 221.19);
  --breakpoint-3xl: 120rem;
}
```

Not JS theme extension by default.

### Source detection
Tailwind v4 scans sources automatically.
Do not add `content` arrays for normal setups.
Use:

```css
@source "../node_modules/@acme/ui-lib";
@source not "../src/legacy";
@source inline("{hover:,}underline");
```

Use `@source inline()` instead of `safelist`.

### Custom utilities
Use:

```css
@utility content-auto {
  content-visibility: auto;
}
```

Not custom utility classes inside `@layer utilities` expecting Tailwind utility behavior.

### Variants in CSS
Use:

```css
.card {
  @variant dark {
    background: black;
  }
}

@custom-variant theme-midnight (&:where([data-theme="midnight"] *));
```

### Reference in isolated style contexts
For CSS modules / Vue / Svelte / Astro style blocks, use:

```css
@reference "../../app.css";
```

or `@reference "tailwindcss"` if only default theme is used.

## Modern config choices

### Vite
Prefer `@tailwindcss/vite`:

```js
import { defineConfig } from "vite"
import tailwindcss from "@tailwindcss/vite"

export default defineConfig({
  plugins: [tailwindcss()],
})
```

### PostCSS
Use `@tailwindcss/postcss`, not `tailwindcss` directly as the plugin.
Usually remove `postcss-import` and `autoprefixer` unless separately needed.

### CLI
Use `@tailwindcss/cli`.

## Tailwind 3 -> 4 rulebook

Apply these when writing new code and when migrating touched code.

### 1. CSS-first, not config-first
Prefer `@theme`, `@utility`, `@variant`, `@custom-variant`, `@source`.
`tailwind.config.js` is legacy/compatibility only.

If a JS config must remain, load it explicitly:

```css
@config "../../tailwind.config.js";
```

But prefer moving definitions to CSS over time.

### 2. `content`, `safelist`, `separator`, `corePlugins`
These are v3 patterns.
In v4:
- no normal `content` config for routine scanning
- no `safelist`; use `@source inline()`
- no `separator`
- no `corePlugins`

### 3. `theme()` is legacy
Prefer CSS variables:

```css
color: var(--color-red-500);
margin: var(--spacing-4);
```

Use `theme(--breakpoint-xl)` only for edge cases like media queries where needed.
Avoid `theme(colors.red.500)` and other dot-notation lookups in new code.

### 4. Arbitrary CSS variable syntax changed
Use:

```html
<div class="bg-(--brand-color)"></div>
```

Not:

```html
<div class="bg-[--brand-color]"></div>
```

When ambiguous, hint the type:

```html
<div class="text-(color:--brand-color)"></div>
<div class="text-(length:--my-size)"></div>
```

### 5. Important modifier moved
Use `!` at the end:

```html
<div class="flex! bg-red-500! hover:bg-red-600!"></div>
```

Not leading `!` syntax.

### 6. Prefixes behave like variants
If a project uses a prefix, write:

```css
@import "tailwindcss" prefix(tw);
```

```html
<div class="tw:flex tw:bg-red-500 tw:hover:bg-red-600"></div>
```

Prefix goes first, like a variant.

### 7. Variant stacking order changed
v4 stacks left-to-right.
Rewrite order-sensitive stacks.

Use:

```html
<ul class="*:first:pt-0 *:last:pb-0"></ul>
```

Not old right-to-left assumptions.

### 8. Arbitrary values with spaces
Use underscores for spaces in arbitrary values.
Especially important in `grid-cols-*`, `grid-rows-*`, and `object-*` values.

Use:

```html
<div class="grid-cols-[max-content_auto]"></div>
```

Not comma-for-space v3 carryover.

### 9. Hover changed on touch devices
`hover:` now only applies when the primary input supports hover.
Don’t rely on hover for essential behavior.
If necessary, override intentionally with:

```css
@custom-variant hover (&:hover);
```

But only when you really need legacy semantics.

### 10. Container config changed
Old v3 container config like `center`/`padding` is gone.
Customize with `@utility`:

```css
@utility container {
  margin-inline: auto;
  padding-inline: 2rem;
}
```

### 11. Defaults that changed
Audit these in migrated/touched code:

- `border`/`divide` default color: now `currentColor`, not gray
- `ring` default width: now `1px`, not `3px`
- `ring` default color: now `currentColor`, not blue
- placeholder default color changed
- buttons now default to `cursor: default`
- `hidden` attribute now beats display utilities

So prefer explicit classes:

```html
<input class="border border-gray-200 ring-3 ring-blue-500" />
```

### 12. Individual transform properties
`scale-*`, `rotate-*`, `translate-*` now use individual CSS properties.
Use `scale-none`, `rotate-none`, etc. instead of assuming `transform-none` resets everything.
If customizing transition properties, include `scale`/`rotate`/`translate`, not only `transform`.

### 13. Modern utility renames
Prefer v4 names:

| Old | Modern |
| --- | --- |
| `shadow-sm` | `shadow-xs` |
| `shadow` | `shadow-sm` |
| `drop-shadow-sm` | `drop-shadow-xs` |
| `drop-shadow` | `drop-shadow-sm` |
| `blur-sm` | `blur-xs` |
| `blur` | `blur-sm` |
| `backdrop-blur-sm` | `backdrop-blur-xs` |
| `backdrop-blur` | `backdrop-blur-sm` |
| `rounded-sm` | `rounded-xs` |
| `rounded` | `rounded-sm` |
| `outline-none` | `outline-hidden` |
| `ring` | `ring-3` |

Also remove deprecated v3 utilities:

- `bg-opacity-*` -> `bg-black/50` style opacity modifiers
- `text-opacity-*` -> `text-black/50`
- `border-opacity-*` -> `border-black/50`
- `divide-opacity-*` -> `divide-black/50`
- `ring-opacity-*` -> `ring-black/50`
- `placeholder-opacity-*` -> `placeholder-black/50`
- `flex-shrink-*` -> `shrink-*`
- `flex-grow-*` -> `grow-*`
- `overflow-ellipsis` -> `text-ellipsis`
- `decoration-slice` -> `box-decoration-slice`
- `decoration-clone` -> `box-decoration-clone`

## Theme rules

### Prefer tokens over ad hoc values
If a value repeats or is meaningful, add it to `@theme`.
If it’s one-off and truly local, arbitrary value is fine.

### Use namespaces correctly
Examples:
- colors: `--color-*`
- fonts: `--font-*`
- text sizes: `--text-*`
- font weights: `--font-weight-*`
- tracking: `--tracking-*`
- leading: `--leading-*`
- breakpoints: `--breakpoint-*`
- containers: `--container-*`
- spacing/sizing: `--spacing-*`
- radius: `--radius-*`
- shadow: `--shadow-*`
- blur: `--blur-*`
- ease: `--ease-*`
- animate: `--animate-*`

### Use `@theme inline` when referencing other variables
Use:

```css
@theme inline {
  --font-sans: var(--font-inter);
}
```

### Use `@theme static` only when you need all variables emitted
Otherwise let Tailwind emit only used vars.

### To replace namespaces fully
Use:

```css
@theme {
  --color-*: initial;
}
```

To replace everything:

```css
@theme {
  --*: initial;
}
```

## Source detection rules

- Keep class names statically detectable.
- Never build utility fragments dynamically like `bg-${color}-500`.
- Map props/state to complete class strings.
- Tailwind scans plain text, not AST/runtime logic.

Prefer:

```js
const colorVariants = {
  blue: "bg-blue-600 hover:bg-blue-500 text-white",
  red: "bg-red-500 hover:bg-red-400 text-white",
}
```

Not string interpolation.

## Modern custom CSS rules

- Prefer markup utilities first.
- Use `@utility` for reusable utilities.
- Use `@layer base` for true base element defaults.
- Use `@layer components` for third-party component overrides or real component CSS.
- Don’t expect `@layer components`/`@layer utilities` custom classes to act like first-class utilities automatically; use `@utility` when you need utility behavior.

## Review checklist

When reviewing Tailwind code, check for:

- old `@tailwind` directives
- `tailwind.config.js` theme extension that should be `@theme`
- `content`/`safelist`/`separator`/`corePlugins`
- `theme()` in new code
- dynamic class construction
- old variable shorthand `bg-[--x]`
- old important syntax `!flex`
- old renamed utilities (`rounded`, `shadow`, `outline-none`, `ring`)
- implicit default border/ring colors
- hover-only UX for critical interactions
- order-sensitive variant stacks still written v3-style
- repeated arbitrary values that should become theme tokens
- old container config patterns

## Preferred answer style when using this skill

Be opinionated. If modern Tailwind can simplify the code, do it.
When touching Tailwind, quietly normalize toward v4 syntax.
If the repo is still on v3, say so briefly and either keep compatibility or propose the smallest clean migration.

## Primary references

Based on Tailwind docs:
- upgrade guide
- theme variables
- functions and directives
- detecting classes in source files
- adding custom styles
- hover/focus and other states
