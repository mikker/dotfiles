---
name: hyperstack-foundations
description: Design and implement peer-to-peer application backends on the Holepunch hyper stack using Corestore, Hyperswarm, Autobase, Hyperbee, Hyperdb, Hyperblobs, Hyperdrive, and adjacent storage primitives. Use for tasks that need storage topology decisions, local-versus-shared state boundaries, replication design, lifecycle and cleanup planning, or backend architecture for a worker, service, or app core.
---

# Hyperstack Foundations

## Overview

Choose the right hyper stack primitives and keep the architecture simple. Favor one long-lived backend owner for replication and storage, then make every persistence decision explicit.

## Core Rules

- Keep one durable storage root per app instance.
- Let one long-lived backend object own `Corestore`, `Hyperswarm`, and any shared indexes.
- Keep renderer or view code away from direct peer-to-peer state when a worker can own it instead.
- Put authoritative shared state in append-friendly replicated structures, not ad hoc files.
- Close managers, contexts, swarms, and auxiliary stores on teardown.

## Choose the Primitive

- Use `Autobase` plus a generated or explicit `Hyperdb` view when many peers append shared domain events and you need deterministic materialization.
- Use `Hyperbee` for local metadata, caches, indexes, and singleton records keyed by stable IDs.
- Use `Hyperblobs` for large binary assets that belong to shared records but should not live inline in the append log.
- Use `Hyperdrive` when the shared object is naturally a file tree or package-like artifact.
- Use plain local files only for host-local concerns that do not need replication semantics.

## Plan the State Split

- Shared, user-visible, conflict-prone state belongs in replicated storage.
- Local preferences, last-opened pointers, UI filters, and caches belong in local metadata tables.
- Derived snapshots should be rebuilt from the shared log or view instead of becoming a second source of truth.
- Temporary join or pairing stores should use separate namespaces and get discarded or finalized deliberately.

## Build in This Order

1. Define the shared entities and which ones truly need replication.
2. Pick the shared primitive per entity type.
3. Define the local metadata tables needed for bootstrap and UX.
4. Decide which process owns the long-lived store and swarm.
5. Define teardown so tests and app shutdown release all resources.

## Load References When Needed

- Read `references/storage-patterns.md` when choosing between Autobase, Hyperbee, Hyperblobs, Hyperdrive, or local-only storage.
- Read `references/proven-approaches.md` when you want examples that have already worked in real apps.
