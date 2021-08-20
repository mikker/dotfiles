set nocompatible

call plug#begin('~/.vim_bundle')

function! s:maybeLocalPlug(args)
  let l:localPath = $HOME . "/dev/" . expand(a:args)

  if isdirectory(l:localPath)
    Plug l:localPath
  else
    Plug 'mikker/' . expand(a:args)
  endif
endfunction

call s:maybeLocalPlug('lightline-theme-pencil')
call s:maybeLocalPlug('vim-rerunner')
call s:maybeLocalPlug('vim-colors-paramount')

" Load this into a register and open plugin repos quickly
" ^f'vi'y:silent !open 'https://github.com/0'

if !has("nvim")
  Plug 'tpope/vim-sensible'
endif

" tpope's the shit
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'

Plug 'itchyny/lightline.vim'

Plug 'AndrewRadev/splitjoin.vim'
Plug 'SirVer/ultisnips'
Plug 'christoomey/vim-tmux-runner'
Plug 'janko-m/vim-test'
Plug 'jreybert/vimagit'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-slash'
Plug 'kana/vim-textobj-user'
Plug 'mattn/emmet-vim'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'rakr/vim-togglebg'
Plug 'reedes/vim-pencil'
Plug 'whiteinge/diffconflicts'
Plug 'wincent/ferret'
if exists('##TextYankPost')
  Plug 'machakann/vim-highlightedyank'
endif

" things

" filetypes and syntax
Plug 'elixir-editors/vim-elixir'
Plug 'mhinz/vim-mix-format'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'slim-template/vim-slim'
Plug 'vim-ruby/vim-ruby'
Plug 'yuezk/vim-js'
Plug 'zackhsi/sorbet.vim'
" Plug 'evanleck/vim-svelte'
" Plug 'junegunn/vim-journal'
" Plug 'jxnblk/vim-mdx-js'
" Plug 'sheerun/vim-polyglot'
Plug 'pantharshit00/vim-prisma'
Plug 'tomlion/vim-solidity'

Plug 'vimwiki/vimwiki'

Plug 'etdev/vim-hexcolor'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

if has("nvim") && !has("gui_vimr")
  Plug 'neovim/nvim-lspconfig'
  Plug 'folke/lsp-colors.nvim'
endif

call plug#end()

