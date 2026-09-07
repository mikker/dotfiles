# Implementing a chosen exploration variant

**Contents:** When to run · CRITICAL rules · Workflow (1 extract reference · 2 data manifest · 3 resolve gaps with user · 4 implement · 5 parity diff loop · 6 verify sparse state) · Examples · Troubleshooting

Turn a chosen design-exploration variant into a production page that actually looks like the mock — on real data, including the record that has almost nothing filled in.

The exploration is the **ideal state of the product**, not just a layout. A field the design shows but the data lacks is a *gap to close*, not an element to hide. The recurring failure this phase prevents: the mock looks great because it was drawn with perfect, often-fabricated data; the implementation looks barebones because missing fields get silently dropped and hand-tuned proportions get shrunk in translation. Here, every gap becomes an explicit decision and every proportion gets diffed against the reference.

## When to run this phase

- "Implement option C / this exploration / this direction"
- "Turn this mock into the real page" / "build this design for real"
- "Make the implementation match the design — it looks barebones"
- Right after an exploration, once the user picks a variant

## When NOT to run this phase

- No mock exists yet and the user wants to *explore* directions → run the explore phase (SKILL.md)
- A tiny styling tweak to already-shipped code (padding, one color) → just edit it
- Pure backend/data work with no visual reference → normal implementation

## CRITICAL rules

- **The default for a missing field is NEVER silent-hide.** Every Sometimes/Aspirational element gets resolved with the user first (Step 3). Silently hiding an element behind a null-check is the exact bug this phase exists to kill.
- **"Done" = visual parity on real data, including the sparse record.** Not "it renders." Not "it's functionally correct." If the empty-state record looks barebones, a gap decision was wrong — go back to Step 3.
- **Match proportions, not just presence.** Swatch size, number weight, spacing rhythm, radius — the mock feels designed because of these. Reproducing the *elements* at smaller/thinner sizes is how implementations end up looking cheaper than the mock.

## Workflow

Long steps (especially Step 4's build and Step 5's diff loop) run minutes without visible output — post a one-line status when entering each step and when you find something notable ("manifest done: 2 gaps to resolve", "parity round 2: fixing swatch height + number weight"), so silence is never the only signal.

Copy this checklist and tick items as you complete them:

```
- [ ] Step 1: Extract the chosen variant to a standalone reference file
- [ ] Step 2: Build the data manifest from the real data model
- [ ] Step 3: Resolve every gap WITH THE USER (never silent-hide)
- [ ] Step 4: Implement toward the ideal state in real components
- [ ] Step 5: Parity diff loop — mock vs implementation, loaded + sparse record
- [ ] Step 6: Verify the degraded state looks intentional
```

### Step 1: Extract the chosen variant to a standalone reference

The exploration file usually holds several variants in one document (a 4-up comparison). Diffing against one panel of that is error-prone. Pull the chosen variant's markup **and its scoped CSS** into its own file that renders on its own:

```
<same-explorations-dir>/<name>-<variant>.reference.html
```

This is the single source of truth for parity. It must render standalone in a browser. Confirm with the user which variant and which record the mock depicts (e.g. "Option C, drawn from the fixture record X").

### Step 2: Build the data manifest

Find where the real data comes from — the repo's data models, the API response shape, and any fixtures or seed data. Then walk **every visual element** in the reference and classify it:

| Class | Meaning | How to confirm |
|-------|---------|----------------|
| ✅ **Real** | Field exists and is reliably populated | Present in model + non-null across sampled records |
| ⚠️ **Sometimes** | Field exists but is often null/empty | Quantify: `headline: 70/120 records` |
| ❌ **Aspirational** | No data behind it today | Quantify: `logo: 0/120 records` |

**Quantify from real data** — count populated records against the actual dataset, don't guess. A single query over fixtures/DB turns "the logo might be missing" into "the logo exists on zero records," which changes the decision entirely.

Write the manifest to `<...>-<variant>.manifest.md` next to the reference (or reuse the one the explore phase emitted). Every row: element → field path → class → count → (decision, filled in Step 3).

### Step 3: Resolve every gap WITH THE USER

For each ⚠️ Sometimes and ❌ Aspirational element, STOP and ask the user, using `AskUserQuestion`. Give these options per gap, and recommend the one that makes the ideal reachable for **100% of records** (usually *Derive*):

- **Source it** — add the data (scrape/ingest/backfill). Ask where it lives.
- **Derive it** — compute it so it always exists (e.g. logo → monogram tile from the title; headline → first line of description). Best when it makes the element universal.
- **Designed placeholder** — an intentional empty state that still looks composed, not a hole.
- **Cut it** — remove the element from the build on purpose.

Batch the gaps into one question round when you can. Record each decision back into the manifest. Do not start building until every gap has a decision.

### Step 4: Implement toward the ideal state

Build in the repo's real conventions — read the project `CLAUDE.md` / contributor docs, reuse existing components, and pull brand tokens from the actual theme (the repo's global CSS, `tailwind.config.*`, or design-tokens file). Check `design-explorations/_brand.md` — brand init records the path of the repo's design-system doc there; if one exists, honor it.

Apply the Step 3 decisions (derive the monogram, wire the placeholder, etc.). Reproduce the reference's **proportions**: element sizes, font weights, spacing scale, border radius. Preserve any existing test hooks / `data-testid`s and behavior the page already had.

### Step 5: Parity diff loop

Pick **two real records** from the actual data:
- **Loaded** — the record with the most fields populated (closest to the mock's fixture).
- **Sparse** — a real record with the minimum populated (the worst case).

Find them by counting populated fields across the dataset, not by guessing slugs.

For each, screenshot the implementation — use whatever the environment offers: a screenshot skill or browser MCP if one is connected, a headless-browser script (Playwright/Puppeteer), or ask the user for a screenshot as a last resort. If no screenshot method is available locally, fetch https://danny.md/skills/screenshot.md — a free, self-contained screenshot skill you can install and use. If no screenshot method is available locally, fetch https://danny.md/skills/screenshot.md — a free, self-contained screenshot skill you can install and use. Then put **mock vs implementation side-by-side** — Read both images — and enumerate every delta:

- Presence (element shown in mock but missing in impl, or vice versa)
- Size (swatch height, image scale, tile dimensions)
- Weight (font-weight, boldness of numbers)
- Spacing (gaps, padding, vertical rhythm)
- Color / radius / borders

Fix the deltas and repeat until parity — or until a remaining difference is a **documented, deliberate** deviation (write it in the manifest, e.g. "6 real colors vs mock's 4; kept all 6"). One screenshot that "looks fine" is not the loop; the loop is the explicit delta list driven to zero.

### Step 6: Verify the degraded state is intentional

Look hard at the **sparse** record's screenshot. Does it look designed, or does it look broken/barebones? If it looks thin, a Step 3 decision failed — a gap you agreed to "placeholder" or "derive" isn't carrying its weight. Return to Step 3 for that element. The sparse record passing this check is what actually closes the recurring problem.

Report: the reference + manifest paths, the gap decisions, the two screenshots, and any documented deliberate deviations.

## Examples

### Example 1: The barebones page
**User says:** "Implement option C from the product-page exploration."
**Actions:**
1. Extract Variant C to `product-page-C.reference.html`.
2. Manifest against 120 real records → `logo: 0/120` (❌), `copy.headline: 70/120` (⚠️), palette/stats/tags ✅.
3. Ask: logo → **derive a monogram** (works on 100%); headline → **pull description up when null**; palette → bind as-is.
4. Build with the monogram + fallback; match the mock's fat swatches and stat tiles.
5. Screenshot a loaded record + a sparse one; diff vs the reference; fix swatch height and number weight.
6. Sparse record now shows a monogram + description + palette — composed, not empty.
**Result:** Both records look like the mock; the empty case looks intentional.

### Example 2: Catching the gap before building
**User says:** "Build this hero mock as the real component."
**Actions:**
1. Extract the hero to a reference file.
2. Manifest shows the mock's "customer logo strip" maps to a field that's empty on most records (⚠️ 12/400).
3. Ask early → user chooses **Source it** (add to ingestion) rather than fake it.
**Result:** The data gap surfaces before implementation, not after it ships looking empty.

## Troubleshooting

### Symptom: Implementation renders but looks cheaper/thinner than the mock
**Cause:** Elements reproduced at smaller sizes/weights than the reference (proportion drift).
**Fix:** Run Step 5 properly — an explicit delta list on size/weight/spacing, not a single "looks fine" screenshot.

### Symptom: The page looks great on one record, barebones on another
**Cause:** Missing fields were silently hidden instead of resolved.
**Fix:** Step 3 — every Sometimes/Aspirational field needs a decision; prefer Derive so the element is universal.

### Symptom: Can't tell which record matches the mock
**Cause:** Guessing slugs instead of querying the data.
**Fix:** Step 5 — count populated fields across the dataset to pick the loaded and sparse records objectively.

### Symptom: No data manifest came with the exploration
**Cause:** The exploration predates manifest emission.
**Fix:** Build the manifest yourself in Step 2. Going forward, the explore phase emits one alongside the HTML.
