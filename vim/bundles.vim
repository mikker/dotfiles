set nocompatible

filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Plugin 'gmarik/vundle'

" tpope's the shit
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-vinegar'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-projectionist'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-commentary'
" ... I mean come on?
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-ragtag'
Plugin 'tpope/vim-tbone'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-rbenv'
Plugin 'tpope/vim-rake'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-markdown'
" Plugin 'tpope/vim-sleuth'

" things
Plugin 'kien/ctrlp.vim'
Plugin 'AndrewRadev/splitjoin.vim'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'mikker/vim-osx-colorpicker'
Plugin 'nelstrom/vim-visual-star-search'

" filetypes and syntax
Plugin 'tpope/vim-haml'
Plugin 'vim-ruby/vim-ruby'
Plugin 'kchmck/vim-coffee-script'
Plugin 'slim-template/vim-slim'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'othree/html5.vim'
Plugin 'JulesWang/css.vim'

" stupid themes
Plugin 'junegunn/seoul256.vim'
Plugin 'w0ng/vim-hybrid'
Plugin 'reedes/vim-colors-pencil'
Plugin 'romainl/Apprentice'

Plugin 'SirVer/ultisnips'
" Plugin 'honza/vim-snippets.git'

filetype on
