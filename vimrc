set nocompatible

" Colorscheme if available
if has("gui_running")
  colorscheme desert 
end

" Enable syntax
syntax on    

" Search
set incsearch
set hlsearch

" Indentation
set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab
set autoindent
set smarttab
set cindent
set autoindent

" Command
set cmdheight=2

" No backup files
set backupdir=$HOME/.vim/backup
set directory=$HOME/.vim/backup

""""
" Key mappings
let mapleader = ","

" NERDTree
map <Leader>d :NERDTreeToggle<CR> :set number<CR>

" Hashrocket shortcut compliments of TextMate
imap <C-L> <space>=><space>

" Quickly delete trailing spaces and tab characters
fun! ClearAllTrailingSpaces()
  %s/\s\+$//
  %s/\t/  /g
endfun

" and map it to <Leader>c
nmap <Leader>c :call ClearAllTrailingSpaces()<CR>

