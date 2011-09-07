set nocompatible
set encoding=utf-8
""""""""""""""""""""""""""
"   Personal vim config  "
"     Mikkel Malmberg    "
"                        "
""""""""""""""""""""""""""

" Setup paths using pathogen
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" { GENERAL }

filetype plugin indent on
syntax on
color desert
set shell=sh " zsh doesn't work so well
set ruler

" Indentation
set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab
set autoindent
set smarttab
set cindent
set autoread
set gdefault    " Global search by default; /g for first-per-row only.

" Preferred file formats
set fileformat=unix
set fileformats=unix,dos,mac

" Tab completion
set wildmode=longest,list
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

" Move by screen lines instead of file lines.
" http://vim.wikia.com/wiki/Moving_by_screen_lines_instead_of_file_lines
noremap <Up> gk
noremap <Down> gj
noremap k gk
noremap j gj
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" Make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv

" Colon is tricky on danish keyboards
map æ :

" Leader
let mapleader = ","

" { PLUGINS }

" NERDTree
map <Leader>d :NERDTreeToggle<CR>
let g:NERDTreeWinPos="right"
let g:NERDMenuMode=0
" let g:NERDTreeWinSize=24

" NERDCommenter
let g:NERDCreateDefaultMappings=0
let g:NERDSpaceDelims=1
map <leader>c <Plug>NERDCommenterToggle

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

" Quicker filetype setting:
"   :F html
" instead of
"   :set ft=html
" Can tab-complete filetype.
command! -nargs=1 -complete=filetype F set filetype=<args>

" Even quicker setting often-used filetypes.
command! FR set filetype=ruby
