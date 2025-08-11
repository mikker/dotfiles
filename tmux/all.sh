#!/bin/bash

set -e

~/.tmux/plugins/tpm/bin/install_plugins

mkdir -p ~/.config
ln -sf ~/.dotfiles/tmux/tmuxinator/ ~/.config/tmuxinator
