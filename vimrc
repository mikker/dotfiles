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

" Use the system clipboard as the default register, '*'
" if has("clipboard")
  " set clipboard=unnamed,exclude:cons\|linux
" endif

" No backup files
set backupdir=$HOME/.vim/backup
set directory=$HOME/.vim/backup


" Without setting this, ZoomWin restores windows in a way that causes
" equalalways behavior to be triggered the next time CommandT is used.
" This is likely a bludgeon to solve some other issue, but it works
set noequalalways

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

" Compliments of TextMate
" Hash rocket (ctrl+l)
imap <C-L> <space>=><space>
" Open new line below (cmd+enter)
imap <D-CR> <ESC>o
map <D-CR> o
" Deselect highlighted search terms
map <D-d> :nohl<CR>
" Toggle hidden characters
map <C-h> :set list!<CR>

" Windows
map <M-D-Left> <C-w>h
map <M-D-Right> <C-w>l
map <M-D-Up> <C-w>k
map <M-D-Down> <C-w>j
" Buffers
map <S-D-Left> :bp!<CR>
map <S-D-Right> :bn!<CR>
map <S-D-BS> :bd!<CR>

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

" Delete all but current buffer

function! Wipeout()
  " list of *all* buffer numbers
  let l:buffers = range(1, bufnr('$'))

  " what tab page are we in?
  let l:currentTab = tabpagenr()
  try
    " go through all tab pages
    let l:tab = 0
    while l:tab < tabpagenr('$')
      let l:tab += 1

      " go through all windows
      let l:win = 0
      while l:win < winnr('$')
        let l:win += 1
        " whatever buffer is in this window in this tab, remove it from
        " l:buffers list
        let l:thisbuf = winbufnr(l:win)
        call remove(l:buffers, index(l:buffers, l:thisbuf))
      endwhile
    endwhile

    " if there are any buffers left, delete them
    if len(l:buffers)
      execute 'bwipeout' join(l:buffers)
    endif
  finally
    " go back to our original tab page
    execute 'tabnext' l:currentTab
  endtry
endfunction

map <C-D-w> :call Wipeout()<CR>

" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,Sitefile,config.ru} set ft=ruby
au BufRead,BufNewFile {*.markdown,*.md} set ft=markdown
au BufRead,BufNewFile *.scss set filetype=scss

" Source a global configuration file if available
if filereadable(expand("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif
