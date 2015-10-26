set nocompatible

call plug#begin('~/.vim/bundle')

" tpope's the shit
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-haystack'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-rbenv'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-afterimage'

" things
Plug 'kien/ctrlp.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'junegunn/vim-easy-align'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'nelstrom/vim-visual-star-search'
Plug 'git@github.com:mikker/sparkup', {'rtp': 'vim/'}
Plug 'SirVer/ultisnips'
Plug 'git@github.com:mikker/vim-rerunner'
Plug 'chrisbra/unicode.vim'
Plug 'grassdog/tagman.vim'
Plug 'tpope/vim-flagship'

" filetypes and syntax
Plug 'sheerun/vim-polyglot'
Plug 'elmcast/elm-vim'

" stupid themes
Plug 'ajh17/Spacegray.vim'
Plug 'cocopon/iceberg.vim'
Plug 'jordwalke/VimCleanColors'
Plug 'junegunn/Zenburn'
Plug 'junegunn/jellybeans.vim'
Plug 'junegunn/seoul256.vim'
Plug 'romainl/Apprentice'
Plug 'w0ng/vim-hybrid'
Plug 'romainl/Disciple'
Plug 'KabbAmine/yowish.vim'

" clojure
Plug 'guns/vim-sexp', { 'for': 'clojure' }
Plug 'junegunn/rainbow_parentheses.vim', { 'for': 'clojure' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'tpope/vim-leiningen', { 'for': 'clojure' }
Plug 'tpope/vim-sexp-mappings-for-regular-people', { 'for': 'clojure' }

Plug 'scrooloose/syntastic'
" Plug 'benekastah/neomake'

call plug#end()

