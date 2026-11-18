---
name: elyx
description: Elyx is a design tool with local, AI-friendly `.elyx` files for screens, components, layouts, flows, and design systems. MANDATORY Use this skill before you read, reason about, or answer any question about Elyx or `.elyx` files. That includes authoring, editing, validating, inspecting, reviewing, refactoring, comparing, and recommending changes, and read-only analysis that produces no edit. Do not reason about `.elyx` files from source text alone. Imports, instances, overrides, and layout resolve only through the `elyx` CLI.
metadata:
  version: "0.0.1-preview.18273.g1dbfdb598f"
  source: elyx-app
---

## How to work in Elyx

This workflow uses the `elyx` command from the public `@elyx-design/cli` npm
package. Before you work with Elyx files, run `elyx --version` to confirm that
`elyx` is on your `PATH`. If it is not, ask the user to install it. For
example:

```bash
npm install --global @elyx-design/cli
```

If a CLI error suggests the CLI is older than the project, such as an unknown
field in `elyx.json`, tell the user in one line: update the Elyx app if
`elyx` came with it, or update `@elyx-design/cli` if they installed it
from npm.

For the authoritative list of flags, run `elyx --help` or `elyx <subcommand> --help`.

### Use `find` and `tree` to see the resolved scene

Use `find` and `tree` to read the scene after imports, instances, overrides, layout, and geometry resolve:

- `find --ref`: get the final data and bounds of one layer by its exact ref.
  `elyx find path/to/file.elyx --ref ctaButton`

- `find --at`: get the topmost rendered layer at a board-space point.
  `elyx find path/to/file.elyx --at 420,180`

- `find --in`: get the layers that intersect a board-space rectangle, or that the rectangle contains.
  `elyx find path/to/file.elyx --in 0,0,800,600`
  `elyx find path/to/file.elyx --in 0,0,800,600 --contain --click-through`

- `tree`: get the semantic layer tree of a file, or of one internal source ref, with children, instance source references, layout, position, constraints, text, and style.
  `elyx tree path/to/file.elyx --ref OnboardingWelcome`
  `elyx tree path/to/file.elyx --ref OnboardingWelcome --depth full`

Pass each point or rectangle as one comma-separated argument, such as `--at "420,180"` or `--in "0,0,800,600"`. Quotes are optional for these values. Negative coordinates also work, for example `--at=-10,20`.

The results use these conventions:

- `localBounds` is geometry in the layer's own space. `absoluteBounds` is geometry in board space.
- In the tree, `position` is the resolved local placement. `constraints` are the stored values that drive layout.
- A value bound to a design token appears as `{"value": …, "token": "<file>#<group>.<member>"}`. The token is the same in every context.
- `instanceOf` gives an instance's source `file`, `symbol`, and `variant`.
- Slot nodes include `slot: true`. Other nodes omit it.
- The tree depth accepts `shallow`, `full`, or a non-negative integer. An integer limits how many instance boundaries the tree crosses.

### Start code from `css`

When you implement a design in code, start from `elyx css` instead of recreating styles from `tree` output. It writes one class per rendered layer, with token references, stack layout, positioning, and clipping resolved. Add `--format json` to get each rule's declarations and the layer `target` it styles.

`elyx css path/to/file.elyx --ref OnboardingWelcome`

### Name things the way users do

When you describe or name Elyx objects, follow these rules:

- Say “layer”, “component”, or “screen” for visual design objects.
- The declaration symbol before `=` is the layer’s name. Keep its leaf name concise, semantic, valid Elyx syntax, and consistent with the project. Do not add a separate `name:` property.
- Use the optional `title:` string for a human-readable label independent of the symbol. Keep the symbol stable when only the label changes.
- Use the optional `caption:` string for a brief note on a screen or example, such as the state it shows. Keep it to a few words that fit within the layer’s width. The canvas truncates a caption wider than its layer.
- Say “symbol” for source identity, imports, references, arguments, and renames.
- Say “token” for design tokens. Say “variable” only for other reusable values that are not layers.

### 1. Orient

Before you assume anything from source examples, use `elyx man` to learn Elyx syntax, concepts, properties, and component semantics. `elyx man` prints the overview manual. `elyx man <topic-or-schema-path>` prints one topic, such as `elyx man components`, `elyx man instance`, or `elyx man frame.width`. If you do not know the right path, run `elyx man --list`.

Before your first edit, run `elyx diagnostics` with no target to learn which warnings the project already has. Step 4 compares against them.

### 2. Author

The project usually already has a design system and its own file vocabulary.
Reuse and import its existing building blocks. Do not build a parallel system.

Prefer composition to recreation. Import and instantiate existing components
instead of rebuilding them from raw layers.

If the project has React components, you can preview them as images, with
no dev server or Storybook, so a design can start from what the codebase
already has. You can also convert one into an Elyx source that claims it. The
`code` documentation covers the setup.

To learn how Elyx projects are organized, run `elyx man project-structure`.
To learn component composition and override semantics, run `elyx man components`, `elyx man instance`, `elyx man variants`, and `elyx man slots`.
To learn what converting React components is for, and how to set up, preview, and convert them, run `elyx man code`.

When you add or change structure, follow these rules:

- Before you write a property you have not used yet, read its documentation. Elyx ignores a property it does not know.
- Import shared components, tokens, and blocks where you can.
- When you create or link a variant, use `@variant` on an instance of its base. It already behaves as a component; do not enable the inspector's Component option (add `export`) just to make it a variant. Export it only when it needs to be reusable outside its file, such as an external variant offered in another file's variant picker.
- Use stacks and `.auto` sizing for normal interface layout. The `frame.layout` documentation describes them.
- Keep overrides local and intentional.
- `title:` and `caption:` are optional. Add them only when the user asks, or when several top-level screens or component examples would be hard to tell apart without them. Most layers need neither, and a title alone is often enough. Keep existing annotations unless the task calls for changing them.
- Capture titles and captions semantically with `title:` and `caption:` so the canvas can draw them as annotations. Do not add separate text layers around a screen or example to represent its title or caption. Text that belongs inside the interface still uses text layers.
- For icons and other vector artwork, write a small SVG file and import it as an asset. The `assets` documentation shows how, including tinting it with `fill`. Do not substitute arbitrary Unicode characters for icons. For SF Symbols with a text representation, use the verified character and explicitly select a compatible SF font. Verify that it contains the glyph.
- Rename symbols one source file at a time. Before you move on, repair the local references and all direct and transitive consumers.
- Before you reason about instances or overrides, read the resolved structure and geometry from the tree.

#### Leave space between canvas items

When you place separate screens, frames, or component examples on a board,
leave at least 48px between the edges of adjacent items. Aim for a gap of at
least 20% of the larger item’s size along the spacing direction. That is the
width for items side by side, and the height for items stacked vertically. For
example, two 1920px-wide screens side by side need about 384px or more between
them, not 48px.

The 20% target is a guideline, not a rigid rule. Keep spacing consistent
within groups, and leave room for frame titles. To measure gaps, use the
resolved bounds of the items. To review the arrangement, render it. This
guidance covers the space between distinct canvas items. It does not cover
padding or gaps inside a screen or component, or intentional overlaps. Do not
re-space unrelated content unless the user asks.

### 3. Render the result

```bash
rg -n --glob '*.elyx' '@context\s*\(' .    # find the context axes and values in the workspace
elyx render path/to/file.elyx -o <tmp>/out.png
elyx render path/to/file.elyx --context theme=dark -o <tmp>/out-dark.png
elyx render path/to/file.elyx --ref <name> --context theme=dark --context lang=pt -o <tmp>/out.png
```

Use `render` whenever the visual result matters. Do not assume that a `.elyx` change is correct from its source text alone.

A render is for you to look at, not part of your work. Write it to a temporary directory outside the repository, shown as `<tmp>` above, then view the PNG. Do not save renders in the project or commit them unless the user asked for the image files.

To render one layer, use `--ref <name>`. To render with custom contexts without changing the source file, repeat `--context axis=value`. Use the context choices registered by the document's imports and `@variants(...)`. Before you render, search the workspace's `@context` annotations to learn the available axes and values.

To preview a React module's components, run `elyx code preview path/to/Module.tsx -o <tmp>/preview`. It needs no dev server, Storybook, or custom harness. It writes one PNG per exported component and prints a JSON report: each component's status (rendered, threw, or empty), size, props schema, render diagnostics, and image path. To preview one export, pass `Module.tsx#Export`. To choose how it renders, repeat `--prop name=value` and set `--width`. A component that throws is a row in the report and doesn't fail the command.

To start an Elyx component from a React one, run `elyx code convert path/to/Module.tsx#Export -o <dir>`, where `<dir>` is a folder in the Elyx project. It creates the folder if it's missing, and never overwrites a file. It writes one new `.elyx` file, made from one render, whose exported declaration claims the component with `meta.code`. Read these fields of its report:

- `slots`: `children` becomes a slot, and so does a prop of kind `node` that's required, given, or has a default, if the component renders it. Each slot holds styled example text to replace.
- `filled`: the props that have no default and were filled. A string is filled with its name. A required array or object is filled with sample data from its type, where `$elyxSample` marks a function or a component that does nothing. Replace sample content the design doesn't want.
- `variants`: with `--variant-prop name`, repeated for each enum or boolean prop to vary, each other value of those props, as a variant of the source overriding what it renders differently, or why it isn't one, such as a value that adds or removes layers. When more than one prop makes variants, their values combine, each combination a variant, on a labelled grid; `variantsNotCombined` says when there would be too many.
- `instances`: the components it renders that a source in the project already claims, each now an instance of that source, or why it keeps its layers. Convert nested components first to get these.
- `props`: the props schema. Other props don't become variants, nor do values that change the layers, so add those the design needs by editing the file.
- `claimedBy`: the sources that already claim the component. Edit one of them rather than keep a second.
- `blank`: true when the render has no text, image, or SVG and a prop that could give it content is unset. Pass that prop.

Render each source you write with `elyx render` before you describe it. A conversion can succeed and still look wrong, so describe only what you saw.

Try a component before you say it can't convert. A report with the status `threw` gives the reason:

- **A missing provider or context.** Add the provider to the root that the report's `root` names. If `root` is null, make a root and name it with `elyx.root` in the package's `package.json`. A root fixes every component in the package. Adding a provider changes the code project, so say so in your final message.
- **A missing parent, or a prop that `--prop` can't set and that sample data doesn't satisfy, such as a component or an object.** Run the command again with `--tsx`, and pass `Module.tsx#Tabs.Root` to say what the module shows. `--tsx` takes a module's text, and its default export renders as if the file sat beside the component. Render a compound part inside its whole family, from its Root.

Use `--tsx` only for these cases. Otherwise, convert the export directly. Preview takes `--tsx` too, and fills props as a conversion does, reporting them in `filled`.

The app's Preview of a `.tsx` file shows that file's exports, filled the same way. If someone wants to see a component there that needs a parent or realistic data, write an ordinary module that assembles it and exports what to show, and have them preview that file. It can have any name, and no convention applies. It changes the code project, so write one only when they ask, and say so in your final message.

The `render` scale defaults to 1. Add `--scale 2` only for fine detail, because it produces four times the pixels.

### 4. Check the project

When your edits are done, normalize each changed file in place. Then check the
whole project for errors and warnings.

```bash
elyx normalize -w path/to/file.elyx
elyx diagnostics   # no target: checks every file in the project
```

A target, such as a file or a folder, checks only that target, and a folder
that is one member of a workspace leaves out the other members. Add
`--importers` to also check every file that imports a target, directly or
through other files, in any member:

```bash
elyx diagnostics --importers path/to/component.elyx
```

Other files may use what you change: a component, a layer inside one, a
variant, or a token. A reference that your change breaks is reported in the
file that uses it, not in the file you edited, so a clean check of the edited
file does not prove the change is safe.

So check the whole project, not only the files you changed. Check it once
before your first edit, to learn which warnings it already has, and again when
your edits are done. Resolve every warning that is new, or account for it
explicitly. Leave the warnings that were already there unless the task is
about them.

While you work, after you change one of those, check its file with importers,
as shown above, to see right away whether a file that uses it broke. That
check does not replace the whole-project check at the end.

If normalization reports that it fell back to syntax-only formatting, the file
loaded with problems, so it was only formatted. Fix the problems it lists,
then normalize the file again.
