# Examples

These are examples, not product requirements.

## Collaborative docs

One app keeps a document context small: Yjs route registration, explicit append methods, snapshots, and worker-owned hydration. That is a good pattern for any CRDT-heavy domain.

## Room domains

One app uses a richer context with roles, queue indexes, config singletons, append-only events, and sidecar blob storage. The important lesson is to keep all permission checks and write rules in the context layer.

## Invite handling

Example workers treat pairing as a streaming operation with a temporary namespace, progress updates, cleanup on cancellation, and a final move into stable manager-owned storage.
