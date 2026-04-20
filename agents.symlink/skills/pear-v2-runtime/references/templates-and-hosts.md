# Templates and Hosts

## Current default

Prefer the modern `hello-pear-*` templates plus the runtime modules over older repo layouts. Copy the structure that matches the host instead of rebuilding runtime wiring from scratch.

## Electron host pattern

- Build the window and preload bridge in Electron.
- Create one `PearRuntime` instance lazily.
- Choose `dir` from an explicit flag, a temp dev location, or the packaged app data directory.
- Guard updates on whether a real `upgrade` link exists.
- Start the backend worker with `runtime.run(...)` and pass `runtime.storage` into it.
- Forward runtime update events to the renderer through the preload bridge.

## Mobile host pattern

- Keep Pear-specific behavior inside the worklet or Bare worker.
- Treat the React Native view layer as a client of that worker.
- Bundle the worker explicitly before native builds.
- Apply OTA updates through the runtime path, not by ad hoc asset swapping.

## Dev-mode rules

- Use explicit storage paths for multi-instance testing.
- Disable updates unless you are testing the update path.
- Keep packaged and dev loading paths separate.
