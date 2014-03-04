set nocompatible

filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

" tpope's the shit
Bundle 'tpope/vim-sensible'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-ragtag'
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-vinegar'
Bundle 'tpope/vim-tbone'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-dispatch'

" things
Bundle 'kien/ctrlp.vim'
Bundle 'vim-scripts/BufOnly.vim'
Bundle 'junegunn/vim-easy-align'
Bundle 'scrooloose/nerdcommenter'
Bundle 'mileszs/ack.vim'
Bundle 'moll/vim-bbye'
Bundle 'nelstrom/vim-visual-star-search'
Bundle 'mikker/sparkup', {'rtp': 'vim/'}
Bundle 'AndrewRadev/splitjoin.vim'
Bundle 'vim-scripts/renamer.vim'
Bundle 'junegunn/goyo.vim'

" filetypes and syntax
Bundle 'vim-ruby/vim-ruby'
Bundle 'kchmck/vim-coffee-script'
Bundle 'tpope/vim-haml'
Bundle 'slim-template/vim-slim'
Bundle 'cakebaker/scss-syntax.vim'
Bundle 'pangloss/vim-javascript'
Bundle 'othree/html5.vim'
Bundle 'JulesWang/css.vim'
Bundle 'msanders/cocoa.vim'

" stupid themes
Bundle 'chriskempson/vim-tomorrow-theme'
Bundle 'junegunn/seoul256.vim'
Bundle 'w0ng/vim-hybrid'
Bundle 'zeis/vim-kolor'

" writing
Bundle 'reedes/vim-pencil'
Bundle 'reedes/vim-colors-pencil'
Bundle 'reedes/vim-wordy'
Bundle 'reedes/vim-wheel'

filetype on
