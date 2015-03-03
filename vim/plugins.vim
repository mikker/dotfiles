set nocompatible

call plug#begin('~/.vim/bundle')

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
Plug 'tpope/vim-haystack'

" things
Plug 'kien/ctrlp.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'mikker/sparkup', {'rtp': 'vim/'}
Plug 'junegunn/vim-easy-align'
Plug 'nelstrom/vim-visual-star-search'
Plug 'thoughtbot/vim-rspec'
Plug 'git@github.com:mikker/snipmate.vim.git'
Plug 'vimwiki/vimwiki', {'on': 'VimwikiIndex'}
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}

" filetypes and syntax
Plug 'vim-ruby/vim-ruby'
Plug 'mustache/vim-mustache-handlebars'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-haml'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'kchmck/vim-coffee-script'
Plug 'slim-template/vim-slim'
Plug 'JulesWang/css.vim'
Plug 'cakebaker/scss-syntax.vim'
Plug 'othree/html5.vim'
Plug 'davidoc/taskpaper.vim'
Plug 'ingydotnet/yaml-vim'
Plug 'puppetlabs/puppet-syntax-vim'
Plug 'briancollins/vim-jst'
Plug 'Keithbsmiley/swift.vim'
Plug 'wting/rust.vim'
Plug 'elixir-lang/vim-elixir'
Plug 'digitaltoad/vim-jade'

" stupid themes
Plug 'junegunn/seoul256.vim'
Plug 'romainl/Apprentice'
Plug 'w0ng/vim-hybrid'
Plug 'sk1418/last256'
Plug 'cocopon/iceberg.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'sjl/badwolf'

" clojure
Plug 'tpope/vim-leiningen', { 'for': 'clojure' }
Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'kien/rainbow_parentheses.vim', { 'for': 'clojure' }
Plug 'guns/vim-sexp', { 'for': 'clojure' }
Plug 'tpope/vim-sexp-mappings-for-regular-people', { 'for': 'clojure' }

call plug#end()

