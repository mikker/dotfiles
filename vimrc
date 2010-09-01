""""""""""""""""""""""""""
"   Personal vim config  "
"     Mikkel Malmberg    "
"                        "
""""""""""""""""""""""""""

" Setup paths using pathogen
call pathogen#runtime_append_all_bundles()


" { GENERAL }

" Dont be vi compatible
set nocompatible

" Indentation
set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab
set autoindent
set smarttab
set cindent
set autoindent

" Preferred file formats
set fileformat=unix
set fileformats=unix,dos,mac

" Enable filetypes and plugins
filetype plugin indent on

" Enable syntax
if has("syntax")
  syntax on
endif

" Use wrap
set wrap

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Search
set incsearch
set hlsearch
set ignorecase
set smartcase

" Use the system clipboard as the default register, '*'
if has("clipboard")
  set clipboard=unnamed,exclude:cons\|linux
endif

" No backup files
set backupdir=$HOME/.vim/backup
set directory=$HOME/.vim/backup



" { LOOKS }

" Colorscheme and font
if has("gui_running")
  colorscheme github
  set guifont=Liberation\ Mono:h14
end

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

" Leader
let mapleader = ","

" Compliments of TextMate
" Hash rocket (ctrl+l)
imap <C-L> <space>=><space>
" Open new line below (cmd+enter)
imap <D-CR> <ESC>o
map <D-CR> o
" Mark current line
imap <D-L> <ESC>V
map <D-L> V
" Deselect highlighted search terms
map <D-d> :nohl<CR>

" Windows
map <M-D-Left> <C-w>h
map <M-D-Right> <C-w>l
map <M-D-Up> <C-w>k
map <M-D-Down> <C-w>j
" Buffers
map <M-S-D-Left> :bp<CR>
map <M-S-D-Right> :bn<CR>
map <M-S-D-BS> :bd<CR>

" { PLUGINS }

" NERDTree
" map <Leader>d :NERDTreeToggle<CR>
" let g:NERDTreeWinPos="right"
" " let g:NERDTreeWinSize=24

" " NERDCommenter
" let g:NERDSpaceDelims=1

" " RagTag
" let g:ragtag_global_maps = 1



" " { OTHER }

" " Automatically strip trailing whitespace
" fun! <SID>StripTrailingWhitespaces()
    " let l = line(".")
    " let c = col(".")
    " %s/\s\+$//e
    " call cursor(l, c)
" endfun

" autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

