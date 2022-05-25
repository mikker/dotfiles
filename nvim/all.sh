#!/bin/bash

mkdir -p ~/.config
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak
ln -sf ~/.dotfiles/nvim ~/.config/nvim

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
   ~/.local/share/nvim/site/pack/packer/start/packer.nvim

