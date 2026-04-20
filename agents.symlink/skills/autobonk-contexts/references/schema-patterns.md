# Autobonk Schema Patterns

## Schema-first workflow

Start with `schema.js`. Define the collections, route payloads, and RPC messages before writing the worker or UI code.

After changing the schema:
- rebuild generated schema artifacts
- rebuild `Hyperdb` helpers
- rebuild dispatch encoders
- rebuild any RPC bundle derived from the same schema

In the common pattern, `schema.js` uses `HyperdbBuilder.from(...)` to generate `spec/db`, and the runtime imports that generated database bundle.

## Useful table shapes

- Append-only event feeds for audit trails and history
- Singleton tables for room or document config
- Keyed membership tables for roster-like state
- Monotonic integer indexes for ordered queues

## Context rules

- Put authoritative writes in `setupRoutes()`
- Require permissions in those routes
- Keep helper methods small and domain-specific
- Seed roles close to the domain constants

## Manager rules

- Create, join, get, list, and remove should be explicit methods
- Keep local metadata in the manager's local store
- Use temporary namespaces during pairing and joins
- Clean up temporary resources on success and on failure
