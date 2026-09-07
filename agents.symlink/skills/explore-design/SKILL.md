---
name: explore-design
description: Generate a single self-contained HTML file showing 3–6 distinct visual directions for a UI section, page, or component side-by-side for comparison, then faithfully implement the variant the user picks. Use when the user asks to "explore directions", "show me a few options", "brainstorm designs", "concept this", "lay out variants", or wants to compare visual approaches before committing to one. Each variant gets a label, a one-line tradeoff, a live rendered preview, and a short analysis. Also use for the follow-up — "implement option C", "build this exploration", "turn this mock into the real page", "make the implementation match the design" — which runs the implementation phase in references/implement.md. Saying "init" or "rebrand the explorations" (re)captures the repo's brand style into a repo-local template.
sources:
  - url: https://x.com/trq212/status/2052809885763747935
    title: Thariq (@trq212) on HTML as agent output
---

# explore-design

Produce ONE standalone `.html` file that lays out several visual directions side-by-side so the user can pick a direction. The output is for visual comparison — it is not production code.

Two phases:
1. **Explore** (this file) — generate the side-by-side comparison.
2. **Implement** — when the user picks a variant or asks to build a mock, read `references/implement.md` in this skill's directory and follow it.

## When to use this skill

- "Explore directions" / "show me a few options" / "brainstorm designs" / "concept this" / "what could this look like"
- "Implement option C" / "build this exploration" / "make the implementation match the mock" (→ phase 2)
- "Init" / "rebrand the explorations" (→ re-run brand init)

## When NOT to use this skill

- Production components wanted directly, with no exploration step and no mock to match → build in the codebase
- An approved direction from outside this skill, no mock to hold parity against → normal implementation
- A tiny styling tweak to shipped code → just edit it

## Workflow

1. **Run the brand scan — always, before anything else:**
   ```
   bash <skill-dir>/scripts/scan-brand.sh <repo-root>
   ```
   Its first section is the init gate:
   - `STATUS: TEMPLATE_FOUND` → tell the user you're reusing their branded template; continue to step 2.
   - `STATUS: NO_TEMPLATE` → read `references/brand-init.md` and complete brand init BEFORE writing any exploration HTML. **No exceptions.** The source mock/wireframe being styled differently is never a reason to skip init — init styles the document chrome only; the mock contributes content, not brand. Init must end with `design-explorations/_template.html` and `_brand.md` on disk.
2. Read the source spec/brief. Identify the **specific surface** being explored (a hero, a card, a page, a flow). If the spec is large, narrow to the highest-leverage surface and say what you scoped to.
3. **Optional — Landingfolio inspiration.** If the Landingfolio MCP is connected (tools named `mcp__landingfolio__*`), pull 3–5 real examples of the surface type being explored (hero, pricing, testimonials, …) and let them inform the variant theses in the next step. If it is NOT installed, never block and never ask — tell the user in one line that you're passing on it, e.g. "Landingfolio MCP not installed — skipping the inspiration pull. Install it at landingfolio.com/mcp if you want reference designs informing the variants." Then continue as normal.
4. Brainstorm 4 distinctly different directions (range 3–6), each with a one-sentence thesis. **Announce them before writing** — "Building 4 directions: A) social-proof-led, B) calculator-led, …" — this is the last message before the longest silent stretch.
5. If the surface renders a data record, sample a real record first (see "Ground variants in real data").
6. Copy `design-explorations/_template.html` to `design-explorations/<short-name>.html` and fill in the page header + variant sections. Use real copy from the spec/codebase.
7. If a data record is involved, emit `<short-name>.manifest.md` (see below).
8. Open the file in the default browser: `open` (macOS) / `xdg-open` (Linux) / `start` (Windows); skip if headless and just report the path.
9. Report: the variants with their one-line tradeoffs, the file path, the manifest path if emitted, and any Aspirational elements to flag.
10. When the user picks a variant (now or later), read `references/implement.md` and follow it.

**Narrate as you go:** the generation stretch runs minutes with no visible output. One-line status at each checkpoint — after the scan (what it found), after scoping, before writing (the variant theses), after writing (the path). A 3-minute silence must never be the first sign of progress.

## Output location

`design-explorations/<short-name>.html` at the repo root (create the directory if missing; mention it may want gitignoring). If the repo has a conventional scratch location, prefer an `explorations/` folder there — the scan script finds templates in either place.

## Structure of the output file

The template gives you the skeleton:

1. **Page header** — title, one-line subtitle, meta strip (date, source spec, surface name)
2. **Variants** — each a section with: letter label + name · a one-line **tradeoff** (what it optimizes for AND gives up) · the live preview (mobile-width ~440px or full-width as fits) · a short **analysis** (≤3 sentences: what works, what risks, when to pick)
3. **Decision row** — "If you want X → pick A. If Y → pick B…"

## Variant design rules

- **Make them actually distinct.** Differing button colors is a wasted format — push on layout, hierarchy, density, tone, and what gets prioritized. If you can't write distinct one-sentence theses, you don't have distinct variants.
- **Each variant names its tradeoff out loud** ("Most confident, least social-proof") so the user picks on tradeoff, not vibes.
- **Use real copy from the spec/codebase.** Lorem ipsum kills the exercise.
- **Variants explore structure, not identity — by default.** Every variant is drawn in the brand captured at init (its fonts, colors, feel) and the exploration happens in layout, hierarchy, density, and what gets prioritized. Going off-brand is allowed ONLY when the user explicitly asks to explore visual identity / rebrand directions.
- **The source spec/mock/wireframe is content, not a style mandate.** Take its copy, structure, and fixtures. Its existing layout is at most one variant's direction among several — the brand the variants wear comes from init, not from the mock.
- **All variants work on the same fixtures** (same product, same data shape). The user compares visual treatments, not features.

## Ground variants in real data (CRITICAL — prevents barebones implementations)

An exploration drawn with fabricated, fully-populated data sets an expectation real data can't meet: the user falls in love with the mock, then the implementation comes out barebones. Two rules:

1. **Pull real data before drawing.** When the surface renders a data record, sample the actual dataset — wherever the repo keeps its data models, API response shapes, fixtures, or seed data — and draw with a real record's values.
2. **Aspirational elements are allowed but disclosed.** Showing a field the product doesn't have yet is fine (it's a spec for what to build) — but tag it in a manifest so the gap is known at pick-time.

**The manifest** (`<short-name>.manifest.md`, next to the HTML): one row per data-bound element — element · field path · class · count. Classes: **✅ Real** (reliably populated) · **⚠️ Sometimes** (often null — quantify, e.g. `70/120`) · **❌ Aspirational** (no data today — quantify). Count from the real dataset, don't guess. The implement phase turns every gap into an explicit source/derive/placeholder/cut decision. Skip the manifest only when there's no data record (e.g. pure marketing copy).

## Style rules

The page **chrome** (header, labels, analysis cards) comes from `_template.html` — the user's brand, captured at init. Don't restyle it per exploration. The **inner preview** of each variant is structurally free canvas but wears the captured brand by default (see Variant design rules); if the brand itself is dark, the previews are dark — that's the brand, not a violation. Scope variant CSS with per-variant prefixes (`.va-`, `.vb-`, …) to avoid cross-bleed.

Hard rules:
- One single HTML file. No CSS files, no JS modules, no Tailwind CDN — vanilla CSS scoped to the page.
- System-font fallbacks on every font stack.
- No dark "AI artifact" aesthetic for chrome (dark gray + neon + monospace everything).
- No comments in the HTML except one top-of-file header block (title, source spec, date).
- Open the file in a browser before reporting done.

## Examples

**"Explore 4 directions for the pricing hero"** → scan (template found) → theses: A) social-proof-led, B) calculator-led, C) tier-comparison-led, D) testimonial-led → `design-explorations/pricing-hero.html` → open → user picks one → implement phase.

**"Let's go with option C — build it"** → read `references/implement.md`: extract variant C to a reference file, build the data manifest, resolve every gap with the user, implement, screenshot-diff to parity.

## Troubleshooting

- **Generated without running init** (no `_template.html`/`_brand.md` on disk): the gate in workflow step 1 was skipped. Run the scan script, complete init, then re-skin the exploration from the branded template.
- **All variants look the same:** theses aren't distinct — rework them before touching CSS.
- **Chrome clashes with the product:** init ran scan-only or captured the wrong brand. Re-run it ("rebrand the explorations").
- **Implementation came out barebones:** gaps were hidden instead of resolved — run the implement phase's manifest + gap-decision steps.
