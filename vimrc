runtime bundle/vim-pathogen/autoload/pathogen.vim

""""""""""""""""""""""""""
"   Personal vim config  "
"     Mikkel Malmberg    "
"                        "
""""""""""""""""""""""""""

filetype off " turn filetype off before loading pathogen
call pathogen#runtime_append_all_bundles() " call in the cavalry
call pathogen#helptags() " and their documentation
filetype plugin indent on " turn filetype back on

" GENERAL

set nocompatible " get with the times
" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=

" Indentation
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Options
set encoding=utf-8 " ensure encoding
set shell=bash " zsh doesn't work so well
set ruler " enable ruler
set backspace=indent,eol,start "  backspace over everything in insert mode
set autoindent " auto indentation on
set smarttab " tab is smart
set autoread " auto-reload files edited elsewhere
set wildmode=longest,list " auto-completion
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn
set fileformat=unix " Preferred file formats
set fileformats=unix,dos,mac " ...
set hidden " allow buffers in background

" Search
nnoremap / /\v
vnoremap / /\v
set ignorecase " search is case insensitive
set smartcase " ... unless you use upper case
set gdefault " global search by default; /g for first-per-row only.
set incsearch " incremental search
set hlsearch " highlight results

" Centralized backup files
set backupdir=$HOME/.vim/backup,/var/tmp,/tmp
set directory=$HOME/.vim/backup,/var/tmp,/tmp

" LOOKS

syntax on
colorscheme desert
" Command
set cmdheight=1
set laststatus=2
set statusline=%F%m%r%h%w\ (%Y)[%v]
" Line numbers
set numberwidth=2
set number

" MAPPINGS

let mapleader = ","

" Quickly jump between two recent files
nnoremap <leader><leader> <c-^>

" Un-highlight search results
map <cr> :nohl<cr>

" Make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv

" Don't move on *
nnoremap * *<c-o>

" Danish keyboards are different
map æ :
noremap - /\v
vnoremap - /\v
noremap _ ^
onoremap _ ^

" Multi-purpose tab-key
" Indent if beginning of line, else do completion
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" Open splits at top level
map <c-w>V :botright :vertical :split<cr>
map <c-w>S :topleft :split<cr>

" Quicker filetype setting:
"   :F html
command! -nargs=1 F set filetype=<args>
command! FR set filetype=ruby

" Automatically strip trailing whitespace
fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun
" autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
map <leader>S :call <SID>StripTrailingWhitespaces()<cr>

" Map ,e to open files in the same directory as the current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%

" Rename current file
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>

" Easy buffer navigation
noremap <C-h>  <C-w>h
noremap <C-j>  <C-w>j
noremap <C-k>  <C-w>k
noremap <C-l>  <C-w>l

" Allow . to execute once for each line of a visual selection
vnoremap . :normal .<CR>

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" PLUGINS

" NERDCommenter
let g:NERDCreateDefaultMappings=0
let g:NERDSpaceDelims=1
" NERDTree
map <leader>d :NERDTreeToggle<CR>

" LOCAL CONFIG

" Source a global configuration file if available
if filereadable(expand("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif
