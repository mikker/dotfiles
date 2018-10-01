#!/bin/bash
set -e

CONF_DIR=~/.config/nvim
mkdir -p $CONF_DIR

if [ ! -f $CONF_DIR/init.vim ]; then
  echo '" load regular vim conf
  set runtimepath+=~/.vim,~/.vim/after
  set packpath+=~/.vim

  source ~/.vimrc' >> $CONF_DIR/init.vim
fi
