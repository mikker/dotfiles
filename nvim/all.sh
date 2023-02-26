#!/bin/bash

mkdir -p ~/.config
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak
ln -sf ~/.dotfiles/nvim ~/.config/nvim

