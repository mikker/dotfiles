---
name: dhh-rails-style
description: This skill should be used when writing Ruby and Rails code in DHH's distinctive 37signals style. It applies when writing Ruby code, Rails applications, creating models, controllers, or any Ruby file. Triggers on Ruby/Rails code generation, refactoring requests, code review, or when the user mentions DHH, 37signals, Basecamp, HEY, or Campfire style. Embodies REST purity, fat models, thin controllers, Current attributes, Hotwire patterns, and the "clarity over cleverness" philosophy.
---

<objective>
Apply 37signals/DHH Rails conventions to Ruby and Rails code. This skill provides domain expertise extracted from analyzing production 37signals codebases (Fizzy/Campfire).
</objective>

<essential_principles>
## Core Philosophy

"The best code is the code you don't write. The second best is the code that's obviously correct."

**Vanilla Rails is plenty:**
- Rich domain models over service objects
- CRUD controllers over custom actions
- Concerns for horizontal code sharing
- Records as state instead of boolean columns
- Database-backed everything (no Redis)
- Build solutions before reaching for gems

**What they deliberately avoid:**
- devise (custom ~150-line auth instead)
- pundit/cancancan (simple role checks in models)
- sidekiq (Solid Queue uses database)
- redis (database for everything)
- view_component (partials work fine)
- GraphQL (REST with Turbo sufficient)
</essential_principles>

<intake>
What are you working on?

1. **Controllers** - REST mapping, concerns, Turbo responses
2. **Models** - Concerns, state records, callbacks, scopes
3. **Views & Frontend** - Turbo, Stimulus, CSS, partials
4. **Architecture** - Routing, multi-tenancy, authentication, jobs
5. **Code Review** - Review code against DHH style
6. **General Guidance** - Philosophy and conventions

**Specify a number or describe your task.**
</intake>

<routing>
| Response | Reference to Read |
|----------|-------------------|
| 1, "controller" | [controllers.md](./references/controllers.md) |
| 2, "model" | [models.md](./references/models.md) |
| 3, "view", "frontend", "turbo", "stimulus", "css" | [frontend.md](./references/frontend.md) |
| 4, "architecture", "routing", "auth", "job" | [architecture.md](./references/architecture.md) |
| 5, "review" | Read all references, then review code |
| 6, general task | Read relevant references based on context |

**After reading relevant references, apply patterns to the user's code.**
</routing>

<quick_reference>
## Naming Conventions

**Verbs:** `card.close`, `card.gild`, `board.publish` (not `set_style` methods)

**Predicates:** `card.closed?`, `card.golden?` (derived from presence of related record)

**Concerns:** Adjectives describing capability (`Closeable`, `Publishable`, `Watchable`)

**Controllers:** Nouns matching resources (`Cards::ClosuresController`)

**Scopes:**
- `chronologically`, `reverse_chronologically`, `alphabetically`, `latest`
- `preloaded` (standard eager loading name)
- `indexed_by`, `sorted_by` (parameterized)

## REST Mapping

Instead of custom actions, create new resources:

```
POST /cards/:id/close    → POST /cards/:id/closure
DELETE /cards/:id/close  → DELETE /cards/:id/closure
POST /cards/:id/archive  → POST /cards/:id/archival
```
</quick_reference>

<reference_index>
## Domain Knowledge

All detailed patterns in `references/`:

| File | Topics |
|------|--------|
| [controllers.md](./references/controllers.md) | REST mapping, concerns, Turbo responses, API patterns |
| [models.md](./references/models.md) | Concerns, state records, callbacks, scopes, POROs |
| [frontend.md](./references/frontend.md) | Turbo, Stimulus, CSS architecture, view patterns |
| [architecture.md](./references/architecture.md) | Routing, auth, jobs, caching, multi-tenancy, config |
| [gems.md](./references/gems.md) | What they use vs avoid, and why |
</reference_index>

<success_criteria>
Code follows DHH style when:
- Controllers map to CRUD verbs on resources
- Models use concerns for horizontal behavior
- State is tracked via records, not booleans
- No unnecessary service objects or abstractions
- Database-backed solutions preferred over external services
- Tests use Minitest with fixtures
- Turbo/Stimulus for interactivity (no heavy JS frameworks)
</success_criteria>

<credits>
Based on [The Unofficial 37signals/DHH Rails Style Guide](https://gist.github.com/marckohlbrugge/d363fb90c89f71bd0c816d24d7642aca) by [Marc Köhlbrugge](https://x.com/marckohlbrugge), generated through deep analysis of the Fizzy codebase.
</credits>
