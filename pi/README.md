# Pi config

Dotfiles-managed Pi setup.

Managed here:

- `settings.json`
- `keybindings.json`
- `extensions/`
- `prompts/`
- `themes/`
- `skills/elyx/` (Elyx agent skill, copied from `elyx-design/agents` at `e41870c`)

Runtime state stays in `~/.pi/agent/`:

- `auth.json`
- `sessions/`
- installed third-party skills/packages

`all.sh` symlinks the managed config files into `~/.pi/agent/`.
Pi then loads this directory as a local package via `packages: ["~/.dotfiles/pi"]` in `settings.json`.

The Elyx skill also needs the separate CLI: `npm install --global @elyx-design/cli`.
