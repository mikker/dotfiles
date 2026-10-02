# Pi config

Dotfiles-managed Pi setup.

Managed here:

- `settings.json`
- `keybindings.json`
- `extensions/`
- `prompts/`
- `skills/elyx/` (Elyx agent skill, copied from `elyx-design/agents` at `e41870c`)

Runtime state stays in `~/.pi/agent/`:

- `auth.json`
- `sessions/`
- installed third-party skills/packages

`all.sh` symlinks the managed config files into `~/.pi/agent/`.
Pi then loads this directory through the local package entry in `settings.json`.

The Elyx skill also needs the separate CLI: `npm install --global @elyx-design/cli`.

## Extensions

- `prompt-box.ts` is disabled by the local package's extension filter; Pi uses its native editor.
- The custom footer shows model, context, speed, and Git status, without a dollar total.
- `$skill` invokes a skill directly; inline `$skills` can combine instructions, including in
  `/skill:name` requests. Relative references resolve from each skill's directory. Mixing inline
  skills with slash prompt templates is rejected rather than silently skipping template expansion.
  Skill-load failures also stop the request.

Run `/reload` after changing configuration or extensions.

## Offline tests

Run the local regression tests against the globally installed Pi:

```sh
node --experimental-test-module-mocks --test ~/.dotfiles/pi/tests/*.test.*
node --test ~/.dotfiles/pi/extensions/apply-patch/tests/offline.test.mjs
```

Set `PI_TEST_HOST` to the installed `@earendil-works/pi-coding-agent` directory to test a
different installation (`PI_TEST_PACKAGE` for the patch-tool suite). Tests mock UI interactions
or use temporary files; they do not call providers.

`my-pi-setup` is loaded as a local package from its existing checkout under
`~/.pi/agent/git/github.com/davis7dotsh/my-pi-setup`. This deliberately prevents Pi package updates
from replacing its local compatibility fixes. Those source changes live in that separate Git
checkout, not this dotfiles directory: preserve it when migrating machines, and review/reconcile
upstream changes manually before updating it.
