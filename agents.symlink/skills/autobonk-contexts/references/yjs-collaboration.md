# Yjs Collaboration on Autobonk

## Prefer the existing split

For collaborative documents or boards, reuse the `autobonk-yjs` shape:
- updates
- snapshots
- awareness

Do not collapse those concerns into one mixed record type.

## Recommended flow

1. Extend schema, DB, and dispatch with the Yjs helpers.
2. Register Yjs routes in the context.
3. Append updates and awareness through explicit domain methods.
4. Record snapshots periodically with revision and state vector information.
5. Let a worker or sync engine hydrate, refresh, and replay awareness for the UI.

## What to keep out of the UI

- direct append logic
- replication lifecycle
- snapshot policy
- historical awareness replay rules
