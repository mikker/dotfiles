# Proven Approaches

These are examples, not requirements.

## Document-style collaboration

One app keeps collaborative document state in a shared replicated context, stores incremental updates and snapshots separately, and uses local metadata tables for bootstrap and invite cache. The worker owns hydration and replay so the UI never manages replication directly.

## Room-style event domains

One app models a room as a single shared context with append-only domain events, singleton config, monotonic queue indexes, and sidecar `Hyperblobs` for media payloads. The worker rebuilds a rich snapshot and streams it to the renderer.

## Board-style CRDT domains

One app keeps board strokes in CRDT-backed update logs with separate presence and snapshot records. A thin context class handles the append routes while the worker owns refresh and watch behavior.
