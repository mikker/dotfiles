set nocompatible
""""""""""""""""""""""""""
"   Personal vim config  "
"     Mikkel Malmberg    "
"                        "
""""""""""""""""""""""""""

" Setup paths using pathogen
call pathogen#runtime_append_all_bundles()

" { GENERAL }

set ruler
syntax on
set shell=sh " zsh doesn't work so well

" Set encoding
set encoding=utf-8

" Indentation
set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab
set autoindent
set smarttab
set cindent

" Preferred file formats
set fileformat=unix
set fileformats=unix,dos,mac

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,test/fixtures/*,vendor/gems/*

" Enable filetypes and plugins
filetype plugin indent on

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Search
set incsearch
set hlsearch
set ignorecase
set smartcase

" No backup files
set backupdir=$HOME/.vim/backup
set directory=$HOME/.vim/backup

" { LOOKS }

" Colorscheme
colorscheme desert

" Command
set cmdheight=1
set laststatus=2
set statusline=%F%m%r%h%w[%{GitBranch()}]\ type:\ %Y,\ pos:\ %l,%v

" Set tab menu 0=never, 1=when more then one, 2=always
set showtabline=1

" Set minimal length of line numbering and set it on
set numberwidth=2
set number


" { MAPPINGS }

" Colon is tricky on danish keyboards
map æ :

" Leader
let mapleader = ","

" { PLUGINS }

" NERDTree
map <Leader>d :NERDTreeToggle<CR>
let g:NERDTreeWinPos="right"
" let g:NERDTreeWinSize=24

" NERDCommenter
let g:NERDSpaceDelims=1

" miniBufExpl
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplModSelTarget = 1

" " { OTHER }

" " Automatically strip trailing whitespace
fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

map <C-D-w> :call Wipeout()<CR>

" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,Sitefile,config.ru} set ft=ruby
au BufRead,BufNewFile {*.markdown,*.md} set ft=markdown

" Source a global configuration file if available
if filereadable(expand("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif
