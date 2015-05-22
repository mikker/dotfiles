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

" things
Plug 'kien/ctrlp.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'AndrewRadev/splitjoin.vim'
Plug 'junegunn/vim-easy-align'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'nelstrom/vim-visual-star-search'
Plug 'thoughtbot/vim-rspec'
Plug 'git@github.com:mikker/sparkup', {'rtp': 'vim/'}
Plug 'git@github.com:mikker/snipmate.vim.git'

" filetypes and syntax
Plug 'tpope/vim-haml'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-markdown'
Plug 'groenewege/vim-less'
Plug 'JulesWang/css.vim'
Plug 'Keithbsmiley/swift.vim'
Plug 'briancollins/vim-jst'
Plug 'cakebaker/scss-syntax.vim'
Plug 'cypok/vim-sml'
Plug 'davidoc/taskpaper.vim'
Plug 'digitaltoad/vim-jade'
Plug 'elixir-lang/vim-elixir'
Plug 'ingydotnet/yaml-vim'
Plug 'kchmck/vim-coffee-script'
Plug 'lluchs/vim-wren'
Plug 'moll/vim-node'
Plug 'mustache/vim-mustache-handlebars'
Plug 'mxw/vim-jsx'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'puppetlabs/puppet-syntax-vim'
Plug 'slim-template/vim-slim'
Plug 'vim-ruby/vim-ruby'
Plug 'wting/rust.vim'

" stupid themes
Plug 'ajh17/Spacegray.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'cdmedia/itg_flat_vim'
Plug 'cocopon/iceberg.vim'
Plug 'jordwalke/VimCleanColors'
Plug 'jordwalke/flatlandia'
Plug 'junegunn/Zenburn'
Plug 'junegunn/jellybeans.vim'
Plug 'junegunn/seoul256.vim'
Plug 'kossnocorp/perfect.vim'
Plug 'nowk/genericdc'
Plug 'romainl/Apprentice'
Plug 'vyshane/vydark-vim-color'
Plug 'w0ng/vim-hybrid'
Plug 'wimstefan/Lightning'

" clojure
Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
Plug 'guns/vim-sexp', { 'for': 'clojure' }
Plug 'junegunn/rainbow_parentheses.vim', { 'for': 'clojure' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'tpope/vim-leiningen', { 'for': 'clojure' }
Plug 'tpope/vim-sexp-mappings-for-regular-people', { 'for': 'clojure' }

Plug 'git@github.com:mikker/vim-rerunner'
Plug 'junegunn/goyo.vim'
Plug 'romainl/vim-qf'
Plug 'junegunn/vim-journal'
Plug 'junegunn/limelight.vim'
Plug 'chrisbra/unicode.vim'

call plug#end()

