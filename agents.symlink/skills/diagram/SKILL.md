---
name: diagram
description: Create and render diagrams with Pele (pele.run), a lightweight Mermaid-to-SVG library. Use for architecture diagrams, flowcharts, sequence diagrams, state machines, schemas, and other visual explanations; also for integrating Pele into a web app.
---

# Diagram

Use [Pele](https://pele.run), not Mermaid.js or hand-positioned SVG. Write Mermaid source, render it, and deliver the actual artifact—not just a code fence.

## Make a diagram

1. Choose the simplest view: flowchart for structure/decisions, sequence for messages over time, state for lifecycles, ER for schemas. Keep labels short and label meaningful edges. Preserve explicit constraints (retry counts, failure paths); do not invent requirements. Split dense diagrams rather than shrinking text.
   - Flowchart: quote node labels with punctuation, e.g. `api["API (v2)"] -->|request| db[(Database)]`.
   - Sequence: message text after `:` is unquoted, e.g. `Client->>API: POST /jobs`.
   - State: alias multi-word names with `state "Dead letter" as DeadLetter`; transition labels after `:` are unquoted.
2. Save editable source as `name.mmd` in the requested output directory (default: current directory).
3. Run the bundled renderer (resolve its path relative to this skill):

   ```sh
   bun /absolute/path/to/diagram/scripts/render.ts name.mmd name.svg
   # Optional: dark palette and/or layout width budget (not forced output width)
   bun /absolute/path/to/diagram/scripts/render.ts name.mmd name.svg --dark --width 800
   ```

   Requires Bun; the first run downloads pinned `pele@1.6.0` into Bun's cache. It does not add a dependency to the user's project. The output path determines where SVG and its self-contained HTML preview are saved; missing directories are created. Do not run `npx pele`: Pele has no CLI.
4. Fix any render errors, then inspect the preview visually if browser/image tools are available. Check labels, arrow direction, clipping, and readability. A successful render alone is not a visual check; say when you could not inspect it.
5. Return links/paths to the SVG, preview, and editable source. PNG is optional, only when requested: capture the HTML preview with an available browser tool. Avoid assuming a generic SVG rasterizer supports CSS variables.

Default to restrained light colors; use `--dark` when requested. Avoid decorative containers, gratuitous color coding, and fixed Mermaid `style`/`classDef` colors that defeat theme switching. Do not upload private diagram source to an online playground.

## In an app

Use the project's package manager to install `pele`. For responsive browser UI:

```js
import { mount } from 'pele';

const diagram = mount(container, source);
diagram.update(nextSource);
// On component teardown:
diagram.destroy();
```

- No bundler: copy `node_modules/pele/dist/pele.global.js` beside the HTML and load it with `<script src="./pele.global.js"></script>`; call `pele.mount(...)`. This works offline without a CDN.
- `mount()` handles container resizes, fonts, unique IDs, and zoom. Use a block container with width independent of the SVG. Mount/update show errors instead of throwing, retaining/dimming the last valid diagram; check `diagram.error` or use `onError`.
- For a one-shot/server render: `const { svg, width, height } = render(source, options)`. `render()` is synchronous and can throw `PeleError`; `supports()` detects an available diagram type, **not** valid syntax. Use `idPrefix` per diagram when inserting multiple SVGs on a page.
- Set `--pele-bg`, `--pele-fg`, `--pele-muted`, `--pele-line`, `--pele-surface`, `--pele-surface-alt`, `--pele-border`, and `--pele-accent` on `.pele` or a parent. Reuse project tokens; change colors without re-rendering. Keep font CSS and measured fonts consistent.
- `maxWidth` can change layout/direction, not just scale; use `autoDirection: false` to preserve source direction. `render()` does not observe resizes.
- For untrusted input, keep default size limits, consider `links: false, images: false`, show errors with `textContent`, and never pass untrusted icon SVG or author-controlled render options.

Look up unfamiliar syntax/options rather than inventing them: [API](https://pele.run/api), [theming](https://pele.run/theming), [security](https://pele.run/security).
