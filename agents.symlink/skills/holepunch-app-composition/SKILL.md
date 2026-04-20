---
name: holepunch-app-composition
description: Compose a complete Holepunch application by assigning responsibilities across the host shell, Pear runtime, backend worker, shared domain layer, RPC boundary, and UI state. Use for tasks that plan or refactor app architecture, decide where features should live, connect Hyperstack primitives to Pear hosts, or turn a product idea into a practical implementation blueprint without coupling it to one specific app.
---

# Holepunch App Composition

## Overview

Use this when the problem is bigger than one library. The goal is to produce a clean architecture where the runtime boots the worker, the worker owns replication, the domain layer owns rules, and the UI consumes snapshots.

## Preferred Shape

- Host shell: windowing, preload bridge, runtime lifecycle, update events.
- Worker or service: long-lived backend, managers, watchers, snapshots, file ingestion.
- Domain layer: contexts, schemas, permissions, replicated data model.
- UI layer: state store, optimistic UX where safe, rendering only.

## Architectural Rules

- Keep app-specific business rules out of the host shell.
- Do not let the renderer talk to Corestore or Hyperswarm directly if a worker can own that state.
- Build one RPC surface per worker and keep it task-oriented, not storage-oriented.
- Let the worker stream snapshots or events to the UI instead of exposing many low-level queries.

## Compose in This Order

1. Define the replicated domain and local metadata split.
2. Choose the host and runtime wiring.
3. Define the worker entrypoint and ownership of managers and watchers.
4. Define the RPC surface the UI actually needs.
5. Shape the UI around snapshots, subscriptions, and task-level mutations.
6. Add test seams at the worker and domain boundaries first.

## Load References When Needed

- Read `references/blueprint.md` for the recommended layer boundaries and build order.
- Read `references/examples.md` for example architectures that have already proven workable.
