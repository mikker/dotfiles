dot-dot-dotfiles

[Init with strap](https://github.com/MikeMcQuaid/strap)

## Install

```sh
git clone --recurse-submodules https://github.com/mikker/dotfiles.git ~/.dotfiles
~/.dotfiles/script/setup --profile desktop   # or: runner
```

The installer supports macOS, Arch/Omarchy, and Debian/Ubuntu. Re-running setup is
safe; the profile is remembered in `~/.config/dotfiles/profile`.

**Profiles.** `desktop` gets GUI apps, window management and system tweaks. `runner`
is headless: shell, editor and command-line tools only. Installers are picked by
filename: `all.sh` runs everywhere, `macos.sh`/`linux.sh` on that platform, and
`macos.desktop.sh`/`linux.desktop.sh` only on desktop machines.

**Who installs what.** mise (`mise/config.toml`) owns runtimes and command-line
tools on every platform. Homebrew (`macos/brew/Brewfile`, plus `Brewfile.desktop`
for desktop Macs), apt and pacman only provide the shell bootstrap, system libraries
and apps.

`script/check --doctor` reports where this machine differs from the config.

On desktop Macs, setup also clones the private `mikker/poof-snippets` repository into
`~/Library/Application Support/Poof/snippets` (requires GitHub SSH access). If that
path already exists, it is left untouched. Snippet changes can be committed and
pushed from that directory; setup does not pull updates automatically.
