# Pi config

Dotfiles-managed Pi setup.

Managed here:
- `settings.json`
- `keybindings.json`
- `extensions/`
- `themes/`

Runtime state stays in `~/.pi/agent/`:
- `auth.json`
- `sessions/`
- installed third-party skills/packages

`all.sh` symlinks the managed config files into `~/.pi/agent/`.
Pi then loads this directory as a local package via `packages: ["~/.dotfiles/pi"]` in `settings.json`.
