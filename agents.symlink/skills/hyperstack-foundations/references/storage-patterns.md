# Hyperstack Storage Patterns

## Shared replicated state

Use `Autobase` when many peers append facts and everyone needs the same derived answer. Model writes as explicit domain events or route messages, then materialize views deterministically.

Use `Hyperdb` when you want the generated or structured shared database layer on top of schema-defined collections. In schema-first apps, `HyperdbBuilder` generates the `spec/db` helpers that shape those collections and queries.

Use `Hyperbee` inside local stores or within the shared view layer for:
- singleton records
- keyed collections
- efficient lookups
- derived indexes

## Local-only state

Use a local `Hyperbee` or another small local store for:
- recently opened items
- cached labels and profile data
- UI preferences
- join history and invite cache

Do not overload replicated storage with host-local convenience data.

## Large payloads

Use `Hyperblobs` when records need binary payloads such as audio, images, or attachments. Store only the blob pointer in the shared row.

Use `Hyperdrive` when the shared artifact is naturally a file tree, release bundle, or package-like dataset.

## Ownership and lifecycle

- Keep one app-level storage root.
- Namespace child stores deliberately.
- Use temporary namespaces for pairing or provisional joins.
- Finalize or discard temporary stores explicitly.
- Close managers, contexts, blob stores, and swarms in tests and on shutdown.

## Practical heuristics

- Conflict-prone shared edits: `Autobase`
- Structured generated shared views: `Hyperdb`
- Read-heavy keyed metadata: `Hyperbee`
- Big binary objects: `Hyperblobs`
- Shared directory trees or app payloads: `Hyperdrive`
- Purely local bootstrap and UX state: local `Hyperbee`
