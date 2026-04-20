# Examples

These are examples, not coupling.

## Thin Electron host plus worker bridge

One app uses Electron only for the window, preload bridge, deep-link handling, and update events. The runtime launches a Bare worker that owns the domain backend, and the renderer talks to it through a narrow bridge.

## Dev storage flags

More than one app uses an explicit `--storage` flag to run multiple local instances without clobbering each other. That pattern is worth keeping.

## Update guarding

Example apps only enable runtime updates when an actual upgrade link is present. In local development they default to `--no-updates` or equivalent behavior.
