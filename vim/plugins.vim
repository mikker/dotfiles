set nocompatible

call plug#begin('~/.vim/bundle')

Plug 'git@github.com:mikker/vim-dimcil'
Plug 'git@github.com:mikker/lightline-theme-pencil'
Plug 'git@github.com:mikker/vim-rerunner'
Plug 'git@github.com:mikker/Disciple'

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
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'

" things
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'junegunn/vim-easy-align'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'nelstrom/vim-visual-star-search'
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
Plug 'SirVer/ultisnips'
Plug 'chrisbra/unicode.vim'
Plug 'grassdog/tagman.vim'
Plug 'thoughtbot/vim-rspec'
Plug 'itchyny/lightline.vim'
Plug 'davidoc/taskpaper.vim'
Plug 'junegunn/gv.vim'
Plug 'junegunn/goyo.vim'
Plug 'Olical/vim-enmasse'
Plug 'janko-m/vim-test'
Plug 'lilydjwg/colorizer'
Plug 'gerw/vim-HiLinkTrace'
Plug 'reedes/vim-pencil'
Plug 'radenling/vim-dispatch-neovim'

" filetypes and syntax
Plug 'sheerun/vim-polyglot'
Plug 'vim-ruby/vim-ruby'
Plug 'mattreduce/vim-mix'
Plug 'ElmCast/elm-vim'
Plug 'hail2u/vim-css3-syntax'
Plug 'vim-ruby/vim-ruby'
Plug 'slim-template/vim-slim'
Plug 'pangloss/vim-javascript'
Plug 'elixir-lang/vim-elixir'
Plug 'slashmili/alchemist.vim'

" stupid colorschemes
Plug 'reedes/vim-colors-pencil'
Plug 'junegunn/seoul256.vim'
Plug 'romainl/Apprentice'
Plug 'w0ng/vim-hybrid'
Plug 'endel/vim-github-colorscheme'
Plug 'mhartington/oceanic-next'

" clojure
Plug 'guns/vim-sexp', { 'for': 'clojure' }
Plug 'junegunn/rainbow_parentheses.vim', { 'for': 'clojure' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'tpope/vim-salve', { 'for': 'clojure' }
Plug 'tpope/vim-sexp-mappings-for-regular-people', { 'for': 'clojure' }

if has("nvim")
  Plug 'benekastah/neomake'
else
  Plug 'scrooloose/syntastic'
endif

call plug#end()

