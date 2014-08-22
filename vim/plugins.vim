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
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-rbenv'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-ragtag'

" things
Plug 'kien/ctrlp.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'mikker/sparkup', {'rtp': 'vim/'}
Plug 'junegunn/vim-easy-align'
Plug 'nelstrom/vim-visual-star-search'
Plug 'vim-scripts/scratch.vim'
Plug 'thoughtbot/vim-rspec'

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
Plug 'davidoc/taskpaper.vim'
Plug 'ingydotnet/yaml-vim'
Plug 'puppetlabs/puppet-syntax-vim'

" stupid themes
Plug 'godlygeek/csapprox'
Plug 'junegunn/seoul256.vim'
Plug 'romainl/Apprentice'
Plug 'w0ng/vim-hybrid'
Plug 'sk1418/last256'
Plug 'cocopon/iceberg.vim'
Plug 'altercation/vim-colors-solarized'

Plug 'SirVer/ultisnips'

" clojure
Plug 'tpope/vim-leiningen', { 'for': 'clojure' }
Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'kien/rainbow_parentheses.vim', { 'for': 'clojure' }

call plug#end()

