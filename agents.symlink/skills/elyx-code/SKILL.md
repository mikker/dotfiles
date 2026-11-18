---
name: elyx-code
description: Translate between Elyx designs and web code. Use this skill to implement or update code from an Elyx design, to create or update an Elyx design from code, to import an existing app into Elyx, or to keep linked design and code in sync.
metadata:
  version: "0.0.1-preview.18273.g1dbfdb598f"
  source: elyx-app
---

# Elyx and code

For Elyx inspection, language documentation, authoring, and validation, use the `elyx` skill. For the target project's framework, components, and checks, follow its `AGENTS.md` and existing code conventions.

## Establish the correspondence

- Identify the requested direction and scope: a component, a screen, a design system, or an app. For an update, inspect the changed side before you edit its counterpart, including its diff when one is available. Keep unrelated states and layers intact.
- Look for existing `meta.code` links, code backlinks, component implementations, tokens, assets, and nearby examples. Treat a link as a lead to verify on both sides, not as proof that everything still matches.
- For an existing Elyx target, run `elyx tree <file> --ref <ref> --depth shallow` and `elyx render <file> --ref <ref> -o <tmp>/out.png` with the relevant context. To see through instances, increase the tree depth. The tree shows inherited `meta` such as `meta.code`, token bindings, and `instanceOf` with its `variant`. Source text alone cannot show the final layout or overrides.
- To inspect or render a descendant inside an instance, reuse a non-null `target` from `find` or `tree` output. Pass its `filePath` as the input file, its `sourceRef` as `--ref`, and its `overridePath`, when present, as `--override-path`. Do not infer an instance occurrence from its display path.
- For feedback on the code side, look in the repo's scripts, docs, and nearby stories for an existing route, preview, or component harness that shows the relevant state. If one is practical to use, compare appearance and behavior with the browser or component tools you have. Accessibility and computed-style feedback can explain what a screenshot cannot. Do not add a browser dependency only for this step. If you cannot inspect the running code, work from source and the existing project checks, and say what you could not observe.

## Elyx to web concept map

Use these analogies as a starting point. Then follow the target framework and the resolved design.

| Elyx | Web code analogy | Check |
| --- | --- | --- |
| Stack `layout: {stack: {direction: .row, item-gap: 8px}}` | `display: flex; flex-direction: row; gap: 8px` | Preserve order, alignment, wrapping, and responsive behavior. Nested stacks or a grid may fit the code better. |
| Grid `layout: {grid: {columns: [1fr, 2fr], column-gap: 8px}}` | `display: grid; grid-template-columns: 1fr 2fr; column-gap: 8px` | Grid properties match CSS grid, with fixed axes. `flow` is `grid-auto-flow`. |
| Freeform children with `left` and `top` | A `position: relative` parent and `position: absolute` children for intentional overlap | Coordinates are relative to the parent. Canvas placement does not need to become app positioning. |
| `.auto`, percentages, `overflow` | Intrinsic sizing, parent-relative percentages, CSS overflow | Like CSS, an Elyx frame shows overflowing content unless it sets `overflow: .clip`. A freeform frame without a size can collapse. |
| Tokens | CSS custom properties, Tailwind theme tokens, or the project's token system | Preserve roles, aliases, and units. |
| `@context` | Theme selectors, locale state, or responsive breakpoints | Inspect which tokens or structural variants change in that context. |
| Component instance (`frame : source`) | A component call, such as `<Card />` | Instance overrides become values that are passed or composed at that use site, not a copied implementation. |
| `@variant` | A prop, state, or style variant in the component API | The Elyx variant inherits its base. Inspect the actual code API before you choose a prop. |
| `slot: .true` on a frame | React `<Card>{content}</Card>` for one region. A named `header` prop or component composition for several regions. | Preserve the region's layout. Elyx source children are example content that instances start with. Decide whether the code supplies a default or leaves the content to callers. |
| `connections: {target: ...}` | Navigation or a transition to another screen, component, or state | The target records the intended destination. Inspect the code for the event, guard, and transition behavior. |

## From Elyx to code

- Reuse the project's components and design tokens. Match a token's semantic role as well as its value. Where a corresponding code token exists, preserve the token binding. If none exists, add a suitable token by the project's conventions, or explain the unresolved mapping. Inspect a component's actual API before you choose props.
- Translate the layout intent into the project's normal responsive layout primitives. Preserve content, assets, typography, and the represented states. For interactive controls, use the project's behavior patterns to preserve selection rules, initial state, disabled behavior, and keyboard access.
- For a flow, read the `connections` declarations in the Elyx source, and follow their targets across files. Component inspection alone does not find them. Map each meaningful destination and branch to the project's routes or state transitions. Then verify in code the interaction that activates each one. A destination does not need to appear on the current board for its connection to be valid.
- For an update, follow the existing design-to-code correspondence. Change the affected implementation instead of recreating it.

## From code to Elyx

- Before you create Elyx tokens, components, contexts, or links, inventory the relevant existing ones. Reuse them where they express the code's roles and structure. When you import a design system, set up the shared tokens and theme contexts before you bind components to them. Preserve the code's base and semantic token layers and its resolved lengths. Verify that representative aliases resolve in each theme.
- To see a React codebase's components, run `elyx code preview Module.tsx`. You get an image per exported component, with each one's status, size, props schema, and render diagnostics, and you need no dev server, Storybook, or custom harness. A preview is reference material. To make a component's Elyx version, convert it with `elyx code convert Module.tsx#Export -o <dir>` rather than recreate its layers by hand. The source it writes claims the component with `meta.code`, and uses the project's tokens where the CSS reads them. A conversion is a first version of the component: it makes slots for the content it takes, variants for the props you name, and instances of the components the project already converted, so convert those first. Render the source to check it, then finish what the report lists, such as variants that add or remove layers. The `code` documentation explains what a conversion is for and the order to convert in, and covers the root component, `--tsx`, and the limits. A codebase may need setup first. Run its CSS build, such as Tailwind or StyleX, and import the output from the root component, which `elyx.root` in the package's `package.json` names. A component that throws for a missing provider needs that provider in the root, not in each render.
- Use components for reused controls, variants for meaningful differences, slots for composable regions, and instances for screen composition. Use stacks for normal UI flow, and freeform placement for intentional overlap or canvas arrangement.
- For named SF Symbol references, resolve the name to its text character. Do not guess code points. If the character cannot be resolved or a compatible font is unavailable, report the limitation.
- Represent one specific, valid UI state. For conditional or data-driven UI, choose representative states. Do not combine branches into a screen that the app cannot show. Capture theme, language, and responsive differences with the project's existing conventions, and with Elyx contexts or variants where they fit.
- When the code has a meaningful flow between represented screens, panels, or states, put a connection on the source control, and target the corresponding Elyx layer. For example, after you import `"./checkout.elyx" as Checkout`, a continue button can use `connections: {target: Checkout.paymentScreen}`. Keep destinations as references, including across files. To see the whole flow at once, use an overview with `draw-connections: .true`.
- For an update, edit the linked declaration or instance that corresponds to the code change. Preserve the shared component and the other instances, unless the code change affects them too.

For example, this code defines a shared default, and one caller supplies a different title:

```tsx
function PlanCard({ title = "Plan" }: { title?: string }) {
  return <article>{title}</article>
}
<PlanCard title="Starter" />
```

The linked Elyx component carries the default. The caller's value belongs on its instance:

```elyx
export planCard = frame {
  children: title,
  title = text {contents: "Plan"}
}
starterCard = frame : planCard {
  title {contents: "Starter"}
}
```

If only that call site changes, update `starterCard`. If the component default changes, update `planCard`. Check the resolved instance before you edit either one.

## Translation details that are easy to miss

Watch for these differences:

- A stacked child ignores `left` and `top`.
- CSS `overflow: hidden` becomes `overflow: .clip` in Elyx. Without it, an Elyx frame lets shadows and overflowing children show, as CSS does.
- Elyx text `letter-spacing` is a percentage of the font size. A positive `line-height` is a multiplier, and `0` means automatic.
- An Elyx variant is an instance of its base with overrides. `@context` selects alternate tokens or contextual variants. By itself, it does not define a web breakpoint or a component prop.

## Link and check the result

- When you have verified the correspondence, put `meta.code` on the narrowest useful Elyx declaration. Use repo-relative paths and stable symbols, as in this pair.

  In `elyx/design/blocks/planCard.elyx`, on the `planCard` declaration:

  ```elyx
  meta: {code: "src/components/blocks/plan-card.tsx#PlanCard"}
  ```

  If the project uses backlinks, above `PlanCard` in the code:

  ```tsx
  // @elyx elyx/design/blocks/planCard.elyx#planCard
  ```

  To go from design to code, open the linked implementation. To go from code to design, search for its backlink or a matching `meta.code`. When a path or symbol moves, update the link. Instances inherit source metadata, so do not copy the component link onto them.
- Render the affected states and contexts. When your edits are done, normalize the changed Elyx files and run full diagnostics on them. Run the project's relevant code checks. If a code preview is available, compare the changed state's appearance and behavior with the design. Report material gaps or unverified states.
