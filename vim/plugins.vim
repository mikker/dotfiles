set nocompatible

call plug#begin('~/.vim/plugged')

" tpope's the shit
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-commentary'
" " ... I mean come on?
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-rbenv'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-characterize'

" things
Plug 'kien/ctrlp.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'mikker/sparkup', {'rtp': 'vim/'}
Plug 'junegunn/vim-easy-align'
Plug 'nelstrom/vim-visual-star-search'
Plug 'vim-scripts/scratch.vim'

" filetypes and syntax
Plug 'vim-ruby/vim-ruby'
Plug 'mustache/vim-mustache-handlebars'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-haml'
Plug 'pangloss/vim-javascript'
Plug 'kchmck/vim-coffee-script'
Plug 'slim-template/vim-slim'
Plug 'JulesWang/css.vim'
Plug 'cakebaker/scss-syntax.vim'
Plug 'othree/html5.vim'
Plug 'wting/rust.vim'

" stupid themes
Plug 'godlygeek/csapprox'
Plug 'junegunn/seoul256.vim'
Plug 'romainl/Apprentice'
Plug 'w0ng/vim-hybrid'
Plug 'sk1418/last256'
Plug 'cocopon/iceberg.vim'

Plug 'SirVer/ultisnips'

" clojure
" Plug 'jpalardy/vim-slime'
" Plug 'tpope/vim-classpath'
" Plug 'tpope/vim-leiningen'
Plug 'guns/vim-clojure-static'
Plug 'tpope/vim-fireplace'
Plug 'kien/rainbow_parentheses.vim'

call plug#end()

