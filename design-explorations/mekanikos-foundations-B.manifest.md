# Frosted Utility implementation manifest

This reference contains no application data records. Every visual element is a shell primitive backed by canonical design tokens, so there are no Sometimes or Aspirational data gaps to resolve.

| Element | Source | Class | Implementation |
|---|---|---|---|
| Raised surface | `color.*.surface-raised` | ✅ Token | Omarchy popups, notifications, tooltips, OSD |
| Double edge | `border.glass.*` | ✅ Token | Theme outer edge + QML inner keyline |
| Floating shadow | `shadow.floating.*` | ✅ Token | OSD, notifications, custom bar tooltips |
| Backdrop blur | `blur.floating` / `blur.tooltip` | ✅ Token | Existing Hyprland popup/layer blur rules |
| Typography | `type.*` | ✅ Token | Generated shell font roles; custom QML consumers |
| Semantic palette | `color.*` / `syntax.*` | ✅ Token | Omarchy and Hunk adapters |
| Audio panel specimen | live `omarchy.audio` component | ✅ Real | Reconstructed from current QML hierarchy and device-state fixture in both modes |
| Accent controls | `control.*` | ✅ Token | Primary actions, on-state switches, checks, slider progress, focus, and selected tint |
| Popup heading hierarchy | `type.*` + semantic colors | ✅ Recipe | Inter title; sentence-case secondary subtitles and section headers without tracking |
| Display P3 accent | `wide-gamut.accent` | ✅ CSS | Gated by CSS syntax support and `color-gamut: p3`; sRGB hex remains the native fallback |
| Compact shell density | `spacing.*` | ✅ Token | Fixed 28px controls and compact panel/row gaps; shared popup padding remains 14px |
| OSD-specific insets | `spacing.osd-padding-*` | ✅ QML | 20px horizontal / 10px vertical; independent from shared PopupCard padding |
| Menu-bar emphasis | `type.bar` | ✅ Shell | Inter Medium, one step above regular UI copy |
| Dark glass edge | `border.glass-dark` | ✅ Shell | White at 22% with an 8% inner keyline; a lighter, more opaque popup/OSD edge |

## Deliberate deviation

First-party Omarchy network, audio, Bluetooth, monitor, power, clock, and agents panels use package-owned `Ui/KeyboardPanel.qml`. Omarchy does not expose a user override or shadow token consumer for this shared component. Their frosted surface and double edge come from the generated theme, but their cast shadow remains pending an upstream shared-component change; cloning every panel would freeze thousands of lines of upstream code and is intentionally rejected.

## Parity checks

- Reference rendered at 1280×900: `/tmp/mekanikos-parity/reference.png`
- Live light-theme capture: `/tmp/mekanikos-parity/screenshot-2026-09-21_13-10-50.png`
- Checked: surface luminosity, edge layering, radius, shadow softness, typography, notification and OSD proportions
- Sparse-state check: not applicable; these primitives do not depend on optional record fields
