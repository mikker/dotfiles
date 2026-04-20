# Composition Blueprint

## Layer split

- Host shell: process lifecycle, windows, preload, deep links, update application
- Runtime: worker launch, app storage path, OTA update mechanics
- Worker: long-lived backend, managers, watch subscriptions, media and file ingestion
- Domain core: contexts, schemas, roles, shared storage rules
- UI: rendering, transient state, user interactions

## Default request flow

1. UI calls a task-oriented RPC method.
2. Worker validates inputs and invokes domain methods.
3. Domain layer writes to the shared replicated storage layer.
4. Worker rebuilds or streams the resulting snapshot.
5. UI updates from that snapshot.

## Default watch flow

1. Worker subscribes to a context or shared resource.
2. Worker converts raw domain state into one UI-facing snapshot shape.
3. UI consumes the snapshot without needing storage-specific knowledge.

## Testing priority

- domain methods and context rules
- worker create or join flows
- watch or snapshot streaming
- host boot and bridge smoke tests
