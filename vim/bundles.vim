set nocompatible

filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Plugin 'gmarik/vundle'

" tpope's the shit
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-vinegar'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-commentary'
" " ... I mean come on?
Plugin 'tpope/vim-projectionist'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-ragtag'
Plugin 'tpope/vim-tbone'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-rbenv'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-rake'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-characterize'

" things
Plugin 'kien/ctrlp.vim'
Plugin 'AndrewRadev/splitjoin.vim'
Plugin 'mikker/sparkup', {'rtp': 'vim/'}
Plugin 'nelstrom/vim-visual-star-search'
Plugin 'vim-scripts/scratch.vim'

" filetypes and syntax
Plugin 'vim-ruby/vim-ruby'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'tpope/vim-liquid'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-haml'
Plugin 'pangloss/vim-javascript'
Plugin 'kchmck/vim-coffee-script'
Plugin 'slim-template/vim-slim'
Plugin 'JulesWang/css.vim'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'othree/html5.vim'
Plugin 'wting/rust.vim'

" stupid themes
Plugin 'junegunn/seoul256.vim'
Plugin 'w0ng/vim-hybrid'
Plugin 'reedes/vim-colors-pencil'
Plugin 'romainl/Apprentice'
Plugin 'noahfrederick/vim-hemisu'

Plugin 'SirVer/ultisnips'
" Plugin 'honza/vim-snippets.git'

Plugin 'jpalardy/vim-slime'

" clojure
Plugin 'guns/vim-clojure-static'
Plugin 'tpope/vim-classpath'
Plugin 'tpope/vim-leiningen'
Plugin 'tpope/vim-fireplace'
Plugin 'kien/rainbow_parentheses.vim'

filetype on
