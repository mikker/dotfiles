set nocompatible
filetype off " turn filetype off before loading pathogen

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'tpope/vim-sensible'
Bundle 'kien/ctrlp.vim'
Bundle 'bling/vim-airline'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-repeat'
Bundle 'skalnik/vim-vroom'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'vim-scripts/BufOnly.vim'
Bundle 'mileszs/ack.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'maxbrunsfeld/vim-yankstack'

Bundle 'tpope/vim-haml'
Bundle 'slim-template/vim-slim'
Bundle 'tpope/vim-liquid'
Bundle 'kchmck/vim-coffee-script'

Bundle 'chriskempson/vim-tomorrow-theme'
Bundle 'Lokaltog/vim-distinguished'

filetype plugin indent on " turn filetype back on

" Prevent Vim from clobbering the scrollback buffer.
" See http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=
set shell=bash " zsh doesn't work so well

set noswapfile
set backupdir-=.
set backupdir^=~/tmp,/tmp
set hidden " allow buffers in background

" Indentation
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set wildmode=longest,list " auto-completion

" Search
nnoremap / /\v
vnoremap / /\v
set ignorecase " search is case insensitive
set smartcase " ... unless you use upper case
set gdefault " global search by default; /g for first-per-row only.
set hlsearch " highlight results

" LOOKS

colorscheme Tomorrow-Night
" Line numbers
set numberwidth=2
set number
" Windows
set winwidth=84
set winheight=3
set winminheight=3
set winheight=999

" MAPPINGS

" cmd+enter opens a new line
imap <D-cr> <c-o>o

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

" I'm too fast for myself
command! W :w

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

" FILETYPES

au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,Sitefile,Podfile,config.ru} set ft=ruby
au BufRead,BufNewFile *.{markdown,mdown,md} set ft=markdown

" PLUGINS

" NERDCommenter
let g:NERDCreateDefaultMappings=0
let g:NERDSpaceDelims=1
map <leader>c <Plug>NERDCommenterToggle
" NERDTree
map <leader>d :NERDTreeToggle<CR>
let g:NERDTreeWinPos = "right"
" Command-T
noremap <leader>f :CtrlP<cr>
noremap <leader>F :CtrlP %%<cr>
" Map keys to go to specific files
noremap <leader>ga :CtrlP app/assets<cr>
noremap <leader>gc :CtrlP app/controllers<cr>
noremap <leader>gh :CtrlP app/helpers<cr>
noremap <leader>gv :CtrlP app/views<cr>
noremap <leader>gm :CtrlP app/models<cr>
noremap <leader>gp :CtrlP public<cr>
noremap <leader>gr :topleft :split config/routes.rb<cr>
noremap <leader>gg :topleft 100 :split Gemfile<cr>
" Airline
let g:airline_powerline_fonts = 1

" LOCAL CONFIG

" Source a global configuration file if available
if filereadable(expand("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif
