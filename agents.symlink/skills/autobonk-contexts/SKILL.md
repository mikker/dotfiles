---
name: autobonk-contexts
description: Define schema-first Autobonk domains with generated schema bundles, `Hyperdb` views, managers, contexts, role-based permissions, pairing flows, and optional Yjs collaboration support through `autobonk-yjs`. Use for tasks that model shared state, write or extend `schema.js`, add routes and permission checks, build create/join flows, or implement deterministic replicated collaboration on top of Autobonk.
---

# Autobonk Contexts

## Overview

Turn a replicated domain into a small number of explicit schemas, routes, and context methods. Favor deterministic tables and route handlers over hidden behavior in UI code.

## Model the Domain First

- Decide which data is append-only history, which data is a singleton, and which data needs monotonic indexes.
- Keep route names and collection names stable and descriptive.
- Define permissions as domain concepts, then let Autobonk enforce them.
- Keep one `Context` subclass as the domain authority for a shared context type.

## Build in This Order

1. Extend `schema.js` with the shared collections and messages.
2. Extend generated DB and dispatch bundles.
3. Implement `Context.setupRoutes()` as the authoritative write surface.
4. Add context methods that encode domain-level operations.
5. Add a manager or worker facade for create, join, get, list, and watch flows.
6. Rebuild generated artifacts after schema changes.

## Permission and Pairing Rules

- Seed role definitions early and keep them close to the domain constants.
- Require permissions in routes, not only in callers.
- Treat pairing and joins as explicit flows with temporary namespaces and cleanup.
- Store only enough local metadata to reopen or relabel contexts quickly.

## Yjs Guidance

- When the replicated artifact is a document, board, or another CRDT surface, prefer `autobonk-yjs` instead of inventing a new update log shape.
- Keep updates, snapshots, and awareness as separate concerns.
- Let a sync engine or worker hydrate and refresh state for the UI.

## Load References When Needed

- Read `references/schema-patterns.md` for domain modeling patterns and generated bundle workflow.
- Read `references/yjs-collaboration.md` for collaborative document or board flows.
- Read `references/examples.md` for approaches that have already worked in app code.
