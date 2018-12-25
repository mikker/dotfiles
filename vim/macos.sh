#!/bin/bash

set -x

if [ ! -x /usr/local/bin/brew ]; then
  echo "Skipping neovim deps for now as there's still no Brew"
  exit 0
fi

pip2 install pynvim --upgrade
pip3 install pynvim --upgrade
gem install neovim
npm install -g neovim
