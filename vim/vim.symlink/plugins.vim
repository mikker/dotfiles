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
call s:maybeLocalPlug('vim-dimcil')
call s:maybeLocalPlug('vim-colors-paramount')
call s:maybeLocalPlug('vim-colors-pap')
call s:maybeLocalPlug('vim-colors-bell')

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

" things
Plug 'AndrewRadev/splitjoin.vim'
Plug 'SirVer/ultisnips'
Plug 'christoomey/vim-tmux-runner'
Plug 'gerw/vim-HiLinkTrace'
Plug 'itchyny/lightline.vim'
Plug 'janko-m/vim-test'
Plug 'jreybert/vimagit'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-slash'
Plug 'mattn/emmet-vim'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'rakr/vim-togglebg'
Plug 'reedes/vim-pencil'
Plug 'whiteinge/diffconflicts'
Plug 'wincent/ferret'
if exists('##TextYankPost')
  Plug 'machakann/vim-highlightedyank'
  let g:highlightedyank_highlight_duration = 100
endif

" filetypes and syntax
Plug 'alampros/vim-styled-jsx'
Plug 'jparise/vim-graphql'
Plug 'junegunn/vim-journal'
Plug 'jxnblk/vim-mdx-js'
Plug 'pangloss/vim-javascript'
Plug 'sheerun/vim-polyglot'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'vim-ruby/vim-ruby'

Plug 'fxn/vim-monochrome'
Plug 'zaki/zazen'
Plug 'pbrisbin/vim-colors-off'
Plug 'arcticicestudio/nord-vim'

Plug 'zackhsi/sorbet.vim'
Plug 'neoclide/coc.nvim', {'do': './install.sh'}
Plug 'liuchengxu/vim-clap'

if has("nvim")
else
  Plug 'tpope/vim-sensible'
endif

call plug#end()

