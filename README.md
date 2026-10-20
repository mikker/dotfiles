dot-dot-dotfiles

[Init with strap](https://github.com/MikeMcQuaid/strap)

## Install

```sh
git clone --recurse-submodules https://github.com/mikker/dotfiles.git ~/.dotfiles
~/.dotfiles/script/setup
```

The installer supports macOS, Arch/Omarchy, and Debian/Ubuntu. macOS dependencies
come from the Brewfile; Linux dependencies use distro-specific package manifests.
Re-running setup is safe.

On macOS, setup also clones the private `mikker/poof-snippets` repository into
`~/Library/Application Support/Poof/snippets` (requires GitHub SSH access). If that
path already exists, it is left untouched. Snippet changes can be committed and
pushed from that directory; setup does not pull updates automatically.
