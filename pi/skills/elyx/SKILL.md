---
name: elyx
description: Elyx is a design tool with local, AI-friendly `.elyx` files for screens, components, layouts, flows, and design systems. This skill is only available to agents running in external harnesses while using the Elyx CLI. It is unavailable and must not be used when running in the ACP harness inside the Elyx app. In external harnesses, use this skill before reading, reasoning about, or answering any question that touches Elyx or `.elyx` files — authoring, editing, validating, inspecting, reviewing, refactoring, comparing, or recommending changes, including read-only analysis where you produce no edit. Do not reason about `.elyx` from source text alone; imports, instances, overrides, and layout only resolve through the tools.
---

MANDATORY Use this skill only when running in an external harness and working through the
Elyx CLI. If you are running in the ACP harness inside the Elyx app, this skill is
unavailable: do not follow its workflow or invoke the CLI on its behalf. Follow
the Elyx app's own instructions and available tools instead. This restriction
applies even if the skill is listed or explicitly requested.

## How to work in Elyx

This skill uses the public `@elyx-design/cli` npm package through its `elyx`
command. Before working with Elyx files, confirm that `elyx` is available on
`PATH` by running `elyx --help`. If it is unavailable, you could use `npx` or 
ask the user to install it with:

```bash
npm install --global @elyx-design/cli
```

Run `elyx --help` or `elyx <subcommand> --help` for the authoritative flags.

### Use `inspect` to see the resolved scene

Use `inspect` to understand the resolved scene after imports, instances, overrides, layout, and geometry have settled.

- `bounds`: resolve one exact layer ref to final layer data and bounds.
  `elyx inspect bounds path/to/file.elyx --ref ctaButton`

- `hit`: find the topmost rendered layer at a board-space point.
  `elyx inspect hit path/to/file.elyx --x 420 --y 180`

- `rect`: find layers intersecting or contained within a board-space rectangle.
  `elyx inspect rect path/to/file.elyx --x 0 --y 0 --width 800 --height 600`
  `elyx inspect rect path/to/file.elyx --x 0 --y 0 --width 800 --height 600 --mode contain --click-through`

- `component`: resolve one internal source ref into a semantic component tree with children, instance source references, layout, position, constraints, text, and style.
  `elyx inspect component path/to/file.elyx --ref OnboardingWelcome`
  `elyx inspect component path/to/file.elyx --ref OnboardingWelcome --depth full`

- `xray`: explain settled X-ray classifications, source counterparts, diff operations, target resolution, and hidden-overlay suppression. By default it returns locally edited and locally introduced layers. Add `--all` for inherited and standalone layers, or `--ref` to scope the traversal to one exact current-file layer ref.
  `elyx inspect xray path/to/file.elyx`
  `elyx inspect xray path/to/file.elyx --ref CardInstance --all`

Key semantics:

- `localBounds` are layer-local geometry; `absoluteBounds` are board-space geometry.
- In `component` output, `position` is resolved local placement; `constraints` are stored layout-driving values.
- `instanceOf` identifies the source file and symbol for an instance.
- Slot nodes include `slot: true` and a `restrictChildren` boolean; non-slot nodes omit both fields.
- `--depth` accepts `shallow`, `full`, or a non-negative integer budget through instance boundaries.
- X-ray classifications are `standalone`, `inherited`, `locallyEdited`, and `locallyIntroduced`. Overlay suppression is `hiddenSelf`, `hiddenAncestor`, `invalidEntity`, or `null`.

### User-facing terminology

When describing or naming Elyx objects:

- Say “layer”, “component”, or “screen” for visual/design objects.
- The declaration symbol before `=` is the layer’s name. Make its leaf name semantic, valid Elyx syntax, and consistent with the project; do not add a separate `name:` property.
- Say “symbol” for source identity, imports, references, CLI arguments, and renames.
- Rename symbols one source file at a time. Repair local references and all direct and transitive consumers before moving on.
- Say “token” for design tokens. Use “variable” only for other reusable non-layer values.

### 1. Orient

Use `elyx man` to learn Elyx syntax, concepts, properties, and component semantics before making assumptions from source examples. `elyx man` prints the overview manual, and `elyx man <topic-or-schema-path>` reads specific documentation such as `elyx man components`, `elyx man instance`, or `elyx man layer.width`. If the right query is unclear, use `elyx man --list`.

The project usually already contains a design system and established file vocabulary. Reuse and import existing building blocks rather than hand-rolling a parallel system.

### 2. Author

Prefer composition over raw recreation. Import and instantiate existing components rather than rebuilding raw layers.
Use `elyx man project-structure` to learn how Elyx projects are organised.
Use `elyx man components`, `elyx man instance`, `elyx man variants`, and `elyx man slots` to learn component composition and override semantics.

When adding or changing structure:

- prefer importing shared components, tokens, and blocks
- prefer stacks and `.auto` sizing for normal interface layout: `elyx man frame.layout`
- keep overrides local and intentional
- use `inspect` to read resolved structure and geometry before reasoning about instances or overrides

### 3. Check

```bash
elyx normalize -w path/to/file.elyx  # normalize edited source in place
elyx diagnostics path/to/file.elyx   # JSON report; no target = scan the project
```

Run normalization after edits, then diagnostics. If `normalize` reports that it
fell back to syntax-only formatting, mention that app-style normalization was not
applied. If the task is broader than one file, run the smallest meaningful scope
that still checks the changed area.

Use `--editor-only` only to reproduce the diagnostics currently displayed in the editor or to isolate parser, evaluation, and import failures. It excludes validation lint and is not suitable for final validation. Final validation must use full diagnostics and resolve or explicitly account for every warning.

### 4. See it

```bash
rg -n --glob '*.elyx' '@context\s*\(' .    # discover context axes and values in the workspace
elyx render path/to/file.elyx -o out.png
elyx render path/to/file.elyx --context theme=dark -o out-dark.png
elyx render path/to/file.elyx --context theme=dark --extra-file path/to/theme-dark.elyx -o out-dark.png
elyx render path/to/file.elyx --symbol <name> --context theme=dark --context lang=pt -o out.png
```

Use `render` whenever visual output matters. Do not assume a `.elyx` change is correct from source text alone.

Use `--symbol <name>` to render one layer. Repeat `--context axis=value` to render with custom contexts without changing the source file. Repeat `--extra-file <file>` to load files that the rendered file does not import; a `--context` selection only changes the output once the file declaring that context is loaded, and without the matching `--extra-file` the render silently falls back to the default values. Search the workspace's `@context` annotations first to learn the available axes and values.

`render` scale defaults to 1; add `--scale 2` only for fine detail because it produces 4x the pixels.
