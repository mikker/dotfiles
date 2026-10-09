---
name: tuna
description: "Configure and troubleshoot an installed Tuna macOS launcher: settings, CLI, sources, extensions, hotkeys, Combo Mode, Smart Links, and custom scripts."
---

# Tuna

Help configure the user's installed **Tuna** macOS launcher. No source checkout or Xcode is
needed. This is not an extension-development or Tuna contributor workflow.

## Discover before changing

- Confirm the requested behavior and installed app version. Use the app's About window; current
  online docs may describe a newer release.
- Locate the active config through **Settings → General → Configuration**, not by assuming the
  default path. Read existing configuration before editing; preserve unrelated values and symlinks.
- Explain the proposed change. Back up the file before edits; never replace a whole configuration
  with an example. Lists and trees are replacements, not patches.
- Do not execute scripts or `run` commands merely to test discovery. Prefer `stage`, then let the
  user inspect the panes. Ask before executing side effects, installing native extensions, connecting
  accounts, or enabling CLI access, shell-command links, or macOS permissions.
- Use the [configuration reference](https://tunaformac.com/docs/configuration) for exact keys,
  accepted values, defaults, and nested shapes. Do not invent settings or IDs. If installed behavior
  differs, inspect what that version writes in Settings before adapting examples.

## Locations and configuration

| Purpose | Default |
| --- | --- |
| Synced configuration | `~/Library/Application Support/Tuna/config.toml` |
| AI prompt Markdown files | `~/Library/Application Support/Tuna/Prompts/` |
| User scripts | `~/Library/Scripts` |
| Installed extensions | `~/Library/Application Support/Tuna/Extensions/` |
| CLI helper | `~/.local/bin/tuna` |

Choose a custom **folder** in General → Configuration; Tuna always uses `config.toml` inside it.
Prompts follow that folder in `Prompts/`; scripts, installed extensions, and the CLI do not move.
Changing folders does not copy/import the old file: back it up, copy it into the chosen folder if
wanted, then reload. A missing config on an untouched installation is normal.

For shell-only discovery on a standard installation, read these local preferences:

```sh
defaults read com.brnbw.Tuna ConfigSyncUsesCustomFolder
defaults read com.brnbw.Tuna ConfigSyncCustomFolderPath
```

Only a true (`1`) custom-folder flag and a nonempty path select `<that folder>/config.toml`.
A missing flag or `0` uses the default folder; a stored path alone does not select it. If results
are unclear, ask the user to confirm the active location in Settings. Do not write these preferences.

TOML is case-sensitive and sparse: Tuna saves overrides and custom data, omitting defaults and
removing an empty file. Settings changes save automatically, atomically, after a short delay.
After the first complete save, a successfully loaded file is the whole synced configuration:
omitted settings/sections reset to defaults (including clearing hotkeys and aliases). Until then,
reload overlays present sections and leaves missing local values alone. A missing file does not
reset settings.

| Section | Contents |
| --- | --- |
| `[settings]` | Synced built-in preferences |
| `[catalogs]` | Sort orders, global-search scopes, search priorities |
| `[catalogConfiguration]` | Folder depths, custom folders/items, script directories |
| `[[catalogSettings]]` | Declared catalog/extension settings; `values` is string-to-string |
| `[hotkeys]` | App shortcuts and custom saved commands |
| `[comboMode]` | Nested key bindings: groups, saved commands, external URLs, typed Tuna routes |
| `[smartLinks]` | Ordered named URL templates, usually using `{{input}}` or `{{clipboard}}` |
| `[aliases]` | Abbreviations pointing at ordered exact items |
| `[actionPreferences]` | Action order and default-action overrides |

Catalog enablement, CLI enablement, and the custom-folder selection are local, not TOML settings.
Learned ranking stays local; tokens and secret settings belong in Keychain, not the file.
For nested structures, record a small example in Settings and inspect the TOML Tuna generates.
Record hotkey chords in **Settings → Hotkeys** rather than calculating Carbon key codes/modifiers.
Use **Settings → Combo Mode → Editor** for nested bindings. Smart Link names are identities;
renaming one by hand also requires updating commands referring to it.

After editing, run `tuna config reload`, choose **Reload from Disk** in Configuration, run
**Reload Tuna Settings from File** in the launcher, or `open 'tuna://config/reload'`.
Only the CLI reports reload success/failure to the shell; `open` just delivers a URL. Check
**Settings → Logs** and any **Config Import Notice**. Tuna validates the whole file before applying
it and rejects unknown fields/sections and invalid references/values. Migration can back up or set
aside old files and report dropped entries. Do not dismiss the notice without reviewing it.
On conflict, choose whether to reload the external file or explicitly overwrite with app state;
do not force an overwrite. Avoid simultaneous Settings edits or writes from another synced Mac.

## CLI: install, enable, check

In **Settings → General → Command Line**, turn on **Enable CLI** (off by default), then use
**Install CLI** if missing, or **Update CLI/Reinstall CLI** as offered. Enabled Tuna repairs the
bundled helper on launch. Put `~/.local/bin` on PATH, e.g. `export PATH="$HOME/.local/bin:$PATH"`;
ask before editing shell startup files.

Read-only checks for a standard installed Tuna:

```sh
command -v tuna
test -x "$HOME/.local/bin/tuna" && printf 'Helper installed\n'
defaults read com.brnbw.Tuna CLIEnabled
```

`1` means enabled; `0` or a missing key means off by default. The Settings toggle is the definitive
UI check. A helper on PATH proves installation, not enablement/connectivity. There is no
`tuna status` or CLI enable subcommand. Running `tuna` with no arguments prints usage, not status.
With the user's approval, `tuna stage 'Tuna CLI check'` verifies a connection without executing
an action (it replaces the staged command and opens Tuna). The helper can launch Tuna and wait up
to 30 seconds; communication is local through an app-owned socket.

```sh
tuna stage <subject> [action] [target]
tuna run [--silent|-s] <subject> <action> [target]
tuna browse [path-or-identifier]
printf 'Alpha\nBeta\n' | tuna pick -
tuna config reload
```

`stage` needs a subject; a target requires an action. `run` needs both subject and action.
CLI subjects/targets accept enabled `catalog-id/item-id` references, existing paths, raw URLs, or
plain text; quote each argument. Actions require `catalog-id/action-id`, e.g. `tuna.common-actions/open`,
not display names such as `Open`. Do not use typed prefixes such as `text:`, `path:`, or `alias:` in
CLI arguments: they are interpreted as URL schemes, not Tuna typed references. Use raw text/paths or
saved commands/command URLs instead. Unresolved item references fall back to text, so inspect the
staged subject before running. `browse` without an argument browses the working directory. `pick --browse` (or `-b`)
interprets input paths relative to it; `--limit N` caps results, `0` removes the cap. A selection is
printed to stdout; cancellation exits non-zero with nothing printed. See the
[CLI reference](https://tunaformac.com/docs/tuna-cli) for details.

## Commands, sources, extensions

A command is **one or more subjects → one action → optional target**. Types and availability decide
which actions/targets fit. For example: file → Open With… → app, or text → Send to Smart Link… → link.
Fuzzy Mode finds items; Text Mode creates text; Talk Mode dictates text; Combo Mode invokes known
commands. Tab changes panes, Right Arrow browses, Return executes. Inline results can become the next
subjects; background work goes to Shelf.

Extensions are native frameworks that declare source catalogs, action catalogs, settings,
connections, and sometimes app enrichments. Source catalogs provide typed, stably identified items:
indexed collections, browse roots, or live provider search. Action catalogs provide verbs; they are
not sources and have no independent source switch. Disabling a source does not remove the installed
extension's actions. Actions can still require an app, connection, or permission.

Install through **Settings → Sources → Find More…** (Extension Store), or
`open 'tuna://settings/extension-store'`. Use **Settings → Sources** to find the provider/catalog,
enable it, and configure permissions/connections. Global search scope is separate from enablement:
**In global search** shows None/Some/All. For Some, select individual items and choose whether new
items should be Included or Not included (`excluding` or `only` scopes in TOML respectively).
Enabled browse/live search roots remain discoverable; item scopes control contents, not the root.
Excluded items can still be browsed or addressed directly; disabled/unloaded sources cannot resolve items.
If something is missing, check installation/load status, source switch, scope, required app,
permissions, connection, and Logs. Rescan data with ⌘R in Tuna; restart when an extension update asks.
Never bypass native-extension trust checks.

In saved commands and `tuna://` command URLs, canonical item/action references are `catalog-id/item-id`
(split at the first slash). Transient subjects/targets use `path:`, `url:`, `text:`, `color:`, or
`alias:`. Titles and Swift class names are not IDs. Use existing saved commands/generated links or
documented IDs, not guessed labels.
Hotkeys and Combo command leaves share this saved-command shape:

```toml
[comboMode]
[[comboMode.bindings]]
key = "e"
label = "Example"
[comboMode.bindings.destination]
type = "command"
[comboMode.bindings.destination.command]
type = "savedCommand"
subjectIdentifiers = ["url:https://example.com"]
actionIdentifier = "tuna.common-actions/open-url"
behavior = "stage"
presentation = "show"
```

Optional `targetIdentifier` needs an action. `behavior` is `run` or `stage`; run requires an action,
stage can omit it. `presentation` is `automatic`, `show`, or `hidden`; stage cannot be hidden and
hidden execution requires a headless-safe action. Preserve existing bindings when adding a leaf.

Without CLI access, use `open 'tuna://settings/general'` or
`open 'tuna://stage?subject=text:hello'`. Command URLs use query parameters `subject`, `action`,
`target`; percent-encode each value. External shell-executing run links are blocked unless the user
enables **Allow shell commands from tuna:// links**; do not enable this as a workaround.
See [URL schemes](https://tunaformac.com/docs/url-schemes).

## Custom scripts

Start with `~/Library/Scripts`. In **Settings → Sources → Tuna → Scripts**, custom directories
require Pro and **replace** the default roots; include `~/Library/Scripts` explicitly to keep it.
Free mode scans only the default. Tuna discovers executable/shebang scripts, AppleScript,
script bundles, Automator workflows, and folder actions. Rescan after adding a script; ensure the
Scripts source is enabled and check its global scope if it is missing from root search.

Executable/shebang scripts and `.applescript` source support leading comment metadata, read until
the first nonblank, noncomment line. Example (creates text, does not modify files):

```sh
#!/bin/sh
# @tuna.name Greeting
# @tuna.input stdin
# @tuna.output text
cat
```

Use script → **Run with Input…** → text/file, or text/file → **Send to Script…** → script. Headers:

- `@tuna.name` (`@tuna.title` alias), `@tuna.subtitle`: display text.
- `@tuna.icon`: `symbol:`, `bundle-id:`, `app:`, or `file:` reference.
- `@tuna.mode`: `inline` (default) or `background` (Shelf task).
- `@tuna.input`: `arguments` (default; argv), `stdin`, or `none` (reject input).
- `@tuna.input-option`: repeatable `Label=value` or bare value; presets allow free-form text too.
- `@tuna.output`: `none` (default), `text` (stdout as text), or `files` (one existing path per stdout
  line; plain paths or `path:` references, `~` expanded). No shell quotes; diagnostics go to stderr.

Comments may begin with `#`, `//`, `--`, or `;`; unknown header values fall back to defaults.
Compiled scripts/bundles/workflows do not use these headers. Review scripts before execution,
quote input safely, and use explicit paths rather than assuming the user's interactive shell PATH.
See [script details](https://tunaformac.com/docs/custom-scripts-and-script-directories).

For other tasks, consult only the relevant public page:
[Smart Links](https://tunaformac.com/docs/smart-links),
[activation/hotkeys](https://tunaformac.com/docs/hotkeys-and-activation),
[extensions](https://tunaformac.com/docs/extensions-overview),
[AI prompts](https://tunaformac.com/docs/ai-prompts) (Markdown in `Prompts/`, `{{input}}` for input;
remote providers receive sent text). Report what changed, reload/check results, and any user steps
still needed; do not claim a configuration works merely because its TOML parses.
