""""""""""""""""""""""""""
"   Personal vim config  "
"     Mikkel Malmberg    "
"                        "
""""""""""""""""""""""""""



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

" Hashrocket shortcut compliments of TextMate
imap <C-L> <space>=><space>



" { PLUGINS }

" NERDTree
map <Leader>d :NERDTreeToggle<CR>
let g:NERDTreeWinPos="right"
let g:NERDTreeWinSize=24

" RagTag
let g:ragtag_global_maps = 1



" { OTHER }

" Automatically strip trailing whitespace
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

