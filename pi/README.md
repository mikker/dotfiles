# Pi config

Dotfiles manage `keybindings.json` and local skills. `all.sh` only symlinks the
keybindings into `~/.pi/agent/`. Settings, package selections, credentials,
sessions, and package checkouts stay local there, not in this repository.

## Fut integration

Pi 1.1.0 and later reports activity to Fut natively via OSC 7501. Launch Pi inside
Fut; no package settings are needed for native status reporting.

For the bundled Fut skill or fallback lifecycle reporting, install the package:

```sh
pi install git:github.com/mikker/fut
```

Restart Pi after installation. An existing local Fut package can stay in your
local settings instead; there is no need to install both. See
[Fut's Pi guide](https://fut.sh/agents/pi/).

## Packages

Package selections are managed locally with `pi install`, `pi remove`, and
`pi config`. The current setup uses:

| Source | Responsibility |
| --- | --- |
| [`mikker/pineapple`](https://github.com/mikker/pineapple) | Questions, background terminals, file search, Firecrawl, subagents, inline skills and prompt box. |
| [`mikker/codex-booster`](https://github.com/mikker/codex-booster) | `apply_patch` and opt-in OpenAI priority service. |
| This directory | Local skills only; extension discovery is explicitly disabled. |
| `~/dev/fut` | Reports agent activity to the Fut workspace. Its skills are excluded here. |

Extensions previously maintained under `pi/extensions/` have been migrated or
removed; do not re-enable duplicate copies. Pineapple leaves the native Pi header
and system theme alone; its footer keeps extension statuses without duplicating
the prompt-box information. There are no Git/model telemetry loops, summaries,
workflows, `/btw`, `/copy-all`, or `/vim-review` extensions.

## Interaction

- Skills: `$name` and `/skill:name` work inline with completion and highlighting.
  Skill files load once per request; references resolve from each skill's actual
  directory. Load failures stop submission. Leading non-skill commands keep their
  native behavior rather than having their arguments reinterpreted.
- Prompt box: dim native-editor-based frame, with victory icon, directory basename,
  branch and Git status on the left; model, enabled fast mode and reasoning on the
  right. Image paths display as numbered `[Image #1]` labels while submission
  preserves the underlying paths. Recognized-skill highlighting/labels, native
  shortcuts, paste, history and completion are retained.
- Questions: native Pi selection and free-form input in TUI/RPC, with cancellation.
  Independent tools may share the batch, but later model turns still wait for the
  answer. Research and limitations are documented in Pineapple's `docs/ask-user.md`.
- Background commands: `bg_start`/status/list/kill, `/ps` and `/ps <id>` inspection.
- Subagents: Pi/Claude Code/Codex spawn/check/wait/cancel/list, plus `/subagents`
  inspection. No takeover or `/btw`.
- Search: install `fd`/`fdfind` and `rg` through the package manager. No automatic
  binary downloads. Web tools require `FIRECRAWL_API_KEY`.
- Priority service: **off by default**. Use `/fast on`, `/fast off`, or `/fast status`.
  It only modifies official OpenAI Responses/Codex endpoints; availability and
  pricing depend on your account/model. Enabled state appears in Pi's status area.

The Elyx skill needs its separate CLI: `npm install --global @elyx-design/cli`.

## Maintenance

```sh
pi update git:github.com/mikker/pineapple
pi update git:github.com/mikker/codex-booster
pi update --all
pi list
```

Restart or `/reload` after package/configuration changes. Git packages are managed
under `~/.pi/agent/git/github.com/mikker/`; local packages are loaded in place.
Development checkouts are `~/dev/pineapple` and `~/dev/codex-booster`: commit and
push there, then update the corresponding managed package. Pineapple preserves
Benjamin Davis's upstream history and MIT attribution; Codex Booster preserves
the OpenAI Codex attribution and Apache-2.0 license for its patch implementation.

## Offline verification

Both package repos provide `npm run check`, `npm run format:check`, and `npm test`.
Tests belong with their implementations, not in these dotfiles. Pi host peers
must be linked for standalone development (see each package's documentation).

Pineapple's `npm test` is offline. Live Claude/Codex tests are deliberately separate
under `npm run test:live` and may make billable provider requests.
