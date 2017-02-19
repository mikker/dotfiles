set nocompatible

call plug#begin('~/.vim/bundle')

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

" tpope's the shit
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-afterimage'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-haystack'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'

" things
Plug 'Alok/notational-fzf-vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'SirVer/ultisnips'
Plug 'ervandew/supertab'
Plug 'gcmt/wildfire.vim'
Plug 'gerw/vim-HiLinkTrace'
Plug 'itchyny/lightline.vim'
Plug 'janko-m/vim-test'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-slash'
Plug 'lilydjwg/colorizer'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'rakr/vim-togglebg'
Plug 'reedes/vim-pencil'
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}


" filetypes and syntax
" Plug 'sheerun/vim-polyglot'

Plug 'ElmCast/elm-vim'
Plug 'c-brenn/phoenix.vim'
Plug 'davidoc/taskpaper.vim'
Plug 'elixir-lang/vim-elixir'
Plug 'hail2u/vim-css3-syntax'
Plug 'mattreduce/vim-mix'
" Plug 'pangloss/vim-javascript'
Plug 'slim-template/vim-slim'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-ruby/vim-ruby'
Plug 'vimwiki/vimwiki'
Plug 'jelera/vim-javascript-syntax'
Plug 'Quramy/vim-js-pretty-template'


" stupid colorschemes
Plug 'kristiandupont/shades-of-teal'
Plug 'pbrisbin/vim-colors-off'
Plug 'romainl/Apprentice'
Plug 'w0ng/vim-hybrid'


if has("nvim")
  Plug 'benekastah/neomake'
else
  Plug 'tpope/vim-sensible'
  Plug 'scrooloose/syntastic'
endif

call plug#end()

