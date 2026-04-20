---
name: pear-v2-runtime
description: Build and wire Pear v2 applications using the current template-plus-runtime approach, especially `hello-pear-*` starters, `pear-runtime`, `pear-mobile`, embedded Bare workers, explicit storage paths, and OTA update flow. Use for tasks that bootstrap a new Pear app, wire an Electron or mobile host, add update handling, separate dev and packaged behavior, or define staging and release flow.
---

# Pear V2 Runtime

## Overview

Use the current Pear direction: start from the modern templates, keep the host thin, and let the runtime own worker execution and update mechanics.

## Default Approach

- Start from the nearest `hello-pear-*` template instead of reconstructing setup from older repos.
- Keep the host responsible for windowing, preload bridges, and app lifecycle only.
- Run peer-to-peer and storage code in a Bare worker launched by the runtime.
- Use explicit storage directories during manual testing so multiple instances do not collide.
- Disable updates in normal local development unless the task is specifically about update flow.

## Build in This Order

1. Choose the host template that matches the app target.
2. Wire `PearRuntime` or the mobile equivalent with explicit `dir`, version, and upgrade settings.
3. Start one backend worker through the runtime and pass the runtime storage path into it.
4. Expose a narrow preload or bridge API to the UI.
5. Handle `updating` and `updated` events in the host.
6. Keep packaged and dev entry paths separate.

## Guardrails

- Avoid mixing direct renderer access to filesystem or peer-to-peer primitives when a worker bridge can own them.
- Avoid assuming updates exist; guard on a real upgrade link.
- Avoid testing multi-instance flows without separate storage paths.
- Always close the runtime during process teardown.

## Load References When Needed

- Read `references/templates-and-hosts.md` for host-specific setup and runtime wiring.
- Read `references/release-flow.md` for Pear OTA staging and deployment decisions.
- Read `references/examples.md` for implementation patterns that have already worked in app repos.
