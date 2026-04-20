# Example Architectures

These are examples, not dependencies.

## Document editor

A document app uses a reusable backend package for the shared domain, an Electron host for the desktop shell, and a separate renderer bundle. The worker runtime lives outside the renderer and owns sync, invite flow, and snapshots.

## Music room

A room app keeps each room in one shared replicated context, puts media payloads in blob storage, and lets a worker stream snapshots containing members, queue, playback, invites, and capability booleans.

## Drawing board

A board app uses a CRDT-first context for shared drawing state and a worker-backed bridge for updates. The UI stays thin and only renders the synchronized board model.
