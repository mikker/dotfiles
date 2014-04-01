set nocompatible

filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Plugin 'gmarik/vundle'

" tpope's the shit
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-rake'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-ragtag'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-vinegar'
Plugin 'tpope/vim-tbone'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-rbenv'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-projectile'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-commentary'

" things
Plugin 'kien/ctrlp.vim'
Plugin 'AndrewRadev/splitjoin.vim'

Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'moll/vim-bbye'
Plugin 'vim-scripts/renamer.vim'
Plugin 'reedes/vim-pencil'
Plugin 'mikker/vim-osx-colorpicker'
Plugin 'junegunn/vim-easy-align'
Plugin 'junegunn/goyo.vim'
Plugin 'nelstrom/vim-visual-star-search'

" Plugin 'sjl/vitality.vim'
" Plugin 'wellle/targets.vim'

" filetypes and syntax
Plugin 'tpope/vim-haml'
Plugin 'vim-ruby/vim-ruby'
Plugin 'kchmck/vim-coffee-script'
Plugin 'slim-template/vim-slim'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'othree/html5.vim'
Plugin 'JulesWang/css.vim'
Plugin 'msanders/cocoa.vim'

" stupid themes
Plugin 'chriskempson/vim-tomorrow-theme'
Plugin 'junegunn/seoul256.vim'
Plugin 'w0ng/vim-hybrid'
Plugin 'reedes/vim-colors-pencil'
" Plugin 'mikker/Spacedust-theme.vim'

filetype on
