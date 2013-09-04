set nocompatible

set nobackup
set nowritebackup
set noswapfile

set ruler
set showcmd
set incsearch
set laststatus=2

" highlight current line
set cursorline

let mapleader = ","

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

filetype plugin indent on

set hidden " allow buffers in background

" Indentation
set tabstop=2
set shiftwidth=2
set expandtab

set wildmenu
set wildmode=list:longest

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  " ack.vim searches with ag
  let g:ackprg = 'ag --nogroup --nocolor --column'
endif

" Search
set ignorecase " search is case insensitive
set smartcase " ... unless you use upper case
set gdefault " global search by default; /g for first-per-row only.
set hlsearch " highlight results

" Color scheme
colorscheme Tomorrow-Night-Eighties

" Line numbers
set number
set numberwidth=5

" Windows
" set winwidth=84
set winheight=3
set winminheight=3
set winheight=999

" MAPPINGS

" Always use \v search
nnoremap / /\v
vnoremap / /\v

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
onoremap _ ^

" I'm too fast for my own good
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

" ,cf to go to nonexisting gf file
map <leader>gf :e <cfile><cr>

" File types

au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,Sitefile,Podfile,config.ru} set ft=ruby
au BufRead,BufNewFile *.{markdown,mdown,md} set ft=markdown

" Plugins

" NERDCommenter
let g:NERDCreateDefaultMappings=0
let g:NERDSpaceDelims=1
map <leader>c <Plug>NERDCommenterToggle
" NERDTree
map <leader>d :NERDTreeToggle<CR>
let g:NERDTreeWinPos = "right"
" CtrlP
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
" let g:airline_powerline_fonts = 1
" Yankstack without meta-key on DK mac keyboard
let g:yankstack_map_keys = 0
nmap ∏ <Plug>yankstack_substitute_newer_paste
nmap π <Plug>yankstack_substitute_older_paste
imap ∏ <Plug>yankstack_substitute_newer_paste
imap π <Plug>yankstack_substitute_older_paste

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

" Local config
if filereadable(expand("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif

let g:airline_powerline_fonts = 1

let g:seoul256_background = 234

map <leader>O :BufOnly<cr>
