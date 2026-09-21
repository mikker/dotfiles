# Mekanikos design system

`tokens.toml` is the hand-authored source of truth. HTML/CSS is the visual publication and review format; generated app files remain native to each consumer.

## Direction

**Frosted Utility** uses luminous translucent surfaces, a double edge, and a broad low-opacity shadow. Every translucent recipe has a solid fallback because blur, compositing, and alpha differ across renderers.

Light and dark are equal modes. They share one semantic contract and geometry; only compositing values and role colors change.

## Core hierarchy

The intentionally small hierarchy prevents each app from inventing near-duplicate values:

- **Accent:** `#1853C7`, the blue used by the active Hyprland window border. Reserve it for active, selected, focused, and actionable state.
- **Text colors:** primary, secondary, muted.
- **Text sizes:** small `12px`, body `14px`, title `16px`.
- **Families:** Inter for UI language; weight is selected separately rather
  than encoded in the family name. Iosevka Nerd Font Mono is reserved for
  code, metadata, and icon glyphs.
- **Bar weight:** the shell bar uses the Inter Medium face because Omarchy's
  plugin API currently exposes only a family string, not a numeric weight.
- **Density:** shell geometry does not scale with the 14px type root. Panels
  use 14px popup padding, 10px horizontal row insets, 10px section gaps, 6px
  row gaps, and 28px controls. OSD-specific density should not change this
  shared popup geometry.
- **OSD density:** volume and playback feedback uses independent `20px`
  horizontal and `10px` vertical padding; it does not inherit PopupCard's
  symmetric padding.
- **Dark glass edge:** dark popup and OSD surfaces use white at `0.22` alpha
  with a `0.08` inner keyline: lighter and more opaque than the background,
  but still quieter than the light-theme edge.
- **Controls:** macOS-like accent emphasis—solid blue primary actions, switches,
  checks, and slider progress; white foregrounds on solid accent fills; softer
  blue tint for persistent list selection.

Popup typography composes those foundations consistently:

- **Title:** title size, primary text, semibold, slightly tightened tracking.
- **Context subtitle:** small size, secondary text, medium weight, no tracking.
- **Section header:** small sentence-case medium text in the secondary color.

Use the `Inter` family at every weight and request weight independently. Do
not use `Inter SemiBold` as a family and then apply bold; Qt synthesizes another
weight pass and the result looks cramped and uneven.

The system stays intentionally small:

- foundations: light/dark color, typography, spacing, radius
- semantics: canvas, raised/alternate surfaces, text, accent, status
- effects: subtle/glass borders, low/floating shadows, blur, motion
- recipes: compose foundations for a specific surface; do not invent component-local colors

## Wide gamut

The sRGB hex values remain canonical fallbacks for native Linux UI, terminals,
TOML themes, and other consumers without explicit color-space support. CSS also
publishes a richer Display P3 accent and activates it only inside both
`@supports (color: color(display-p3 ...))` and `@media (color-gamut: p3)`.

That distinction matters: parsing Display P3 syntax does not prove the complete
display pipeline is wide gamut. The compositor, output profile, application,
and monitor must all participate. Unsupported consumers continue to receive
`#1853C7` without conversion or clipping surprises.

## Files

- `tokens.toml` — canonical values
- `tokens.css` — generated CSS custom properties
- `../design-explorations/mekanikos-foundations-B.reference.html` — visual reference
- `../script/design-system` — generator and drift check

Run:

```sh
script/design-system generate
script/design-system check
```

`script/check` runs the drift check too.

## Mapping policy

Generate values, not behavior. QML structure, Hyprland rules, application bindings, and accessibility behavior remain handwritten.

Current generated consumers:

- Mekanikos light/dark foundational palettes
- Omarchy popup, notification, and tooltip theme fragments for both modes
- Omarchy control-state fragments for hover, focus, selection, and toggles
- Complete Omarchy bar, menu, launcher, and Hyprland-border sections for both
  modes, so section replacement cannot silently drop text or surface colors
- Hunk light/dark semantic and syntax themes
- CSS custom properties for publication and browser styling

Next adapters should be added one family at a time: Pi, remaining terminal/editor syntax, browser sprinkles, then macOS shell chrome. Their semantic role mapping should be reviewed before generation replaces existing files.

## Omarchy constraint

User-owned OSD, notifications, bar tooltip, and tray popup code can consume the effect tokens now. First-party network/audio/Bluetooth/power panels use package-owned `Ui/KeyboardPanel.qml`; Omarchy currently has no supported user override for that shared component. A small upstream shadow-token consumer is preferable to cloning every panel and freezing upstream code.
