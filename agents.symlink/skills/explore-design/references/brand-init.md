# Brand init — set up the repo-local branded template

Runs when `scripts/scan-brand.sh` reports `NO_TEMPLATE`, or when the user says "init", "re-init", or "rebrand the explorations". It produces two files that every future exploration reuses:

- `design-explorations/_template.html` — the branded template (copy of `assets/template.html` with real tokens applied)
- `design-explorations/_brand.md` — hand-editable record of what was detected/chosen, including the path of any design-system doc

Announce what you're doing before starting: "No branded template yet — running brand init first."

## 1. Interpret the scan output

`scan-brand.sh` already printed the raw material — don't re-scan by hand:

- **Design-system docs found** (a `DESIGN.md`, `design-system.md`, style guide, tokens directory): read the most authoritative one. Treat it as the source of truth for mood, vibe, fonts, and colors.
- **Theme/token files found** (tailwind config, `:root` custom properties): extract candidate primary/accent colors and fonts. Where a doc and the code disagree, the code wins (docs drift).
- **Nothing found**: neutral defaults (step 3).

## 2. What brand init is — and is NOT

Brand init styles the **document chrome only** (header, labels, analysis cards): the quiet frame around the variants. Sources, in order: the host repo's design system → neutral defaults. That's it.

The exploration's source spec/mock/wireframe is **never a brand input**. It contributes copy, structure, and fixtures — the variants explore visual directions freely and are not bound to its styling (nor to the chrome's). Do not capture a mock's colors into `_template.html`, and do not skip init because "the brand comes from the mock".

## 3. Apply the brand — never block on questions

Applying the detected brand is the DEFAULT. It needs no confirmation, and autonomous/auto-mode sessions must still come out with branded chrome — "non-interactive" is never a reason to fall back to neutral when a brand was detected.

- **Brand detected** (design-system doc or theme tokens) → apply it via the light adaptation below and continue.
- **Nothing detected** → neutral defaults, continue.
- **Ask only when** the scan surfaced multiple genuinely conflicting brand candidates and you can ask (one short `AskUserQuestion` round). If asking is impossible, pick the most product-central candidate and proceed — never neutral.
- **Dark chrome is opt-in**: only when the user explicitly asks for it. A brand whose tokens are dark still gets applied — adapted, not discarded.
- End the run report with what was applied and: "say 'rebrand the explorations' to adjust the chrome."

### Light adaptation — how to apply any brand without clashing

The chrome is a quiet frame; translate the brand onto light paper instead of copying its surfaces:

- **Paper:** light neutral background, tinted faintly toward the brand's temperature.
- **Ink:** the brand's darkest color — a dark background token makes excellent ink.
- **Accents:** the brand's hue identity (primary/secondary) on the eyebrow, letter badges, labels, and links, contrast-adjusted for light paper.
- **Fonts:** keep the brand's fonts. A monospace brand stack goes on accents and meta (eyebrow, preview bars, labels) while body text stays readable — the brand's body font, or the neutral default if the brand has none.
- **Radius, spacing, density:** follow the brand's feel.

The result should be unmistakably *their* brand at a glance, while any variant — light, dark, loud — can sit inside it without the frame competing.

## 4. Write the two files

1. Copy `assets/template.html` (in this skill's directory) to `design-explorations/_template.html`.
2. Apply the adapted tokens to its `:root` block, Google Fonts links, and spacing/radius choices.

   Apply the light adaptation from step 3 — the brand must be visibly present in the chrome (hues, fonts, ink), on light paper, unless the user explicitly asked for dark chrome.
3. Sanity-check the written template: confirm the chrome reads as a quiet frame that lets any variant — light, dark, loud — sit inside it without competing.
4. Write `design-explorations/_brand.md`: detected sources (with paths), the adaptation choices made, the design-system doc path if any, and the date. Keep it short and hand-editable — future re-inits diff against it, and the implement phase reads it to find the full design system.

Then return to the exploration workflow with the new template.
