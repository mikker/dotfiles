set nocompatible

if filereadable(expand("~/.vim/bundles.vim"))
  source ~/.vim/bundles.vim
endif

filetype plugin indent on

set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
if exists("+undofile")
  set undofile
  set undodir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
endif

" highlight current line
set cursorline

let mapleader = ","

" set mouse=a

set hidden " allow buffers in background

" Indentation
set tabstop=2
set shiftwidth=2
set expandtab

" Completion
set wildmode=longest:list,full
" set wildignore+=tags

set showcmd

" ag for ack
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
" let g:hybrid_use_iTerm_colors = 1
colorscheme hybrid

" Line numbers
set number
set numberwidth=3

" Windows
set winheight=3
set winminheight=3
set winheight=999

" Always use \v search
" nnoremap / /\v
" vnoremap / /\v

" Quickly jump between two recent files
nnoremap <leader><leader> <c-^>

" Un-highlight search results
map <cr> :nohl<cr>

" Make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv

" fold by syntax
set foldmethod=syntax " fold by syntax
set foldlevel=20 " folds come expanded
set foldlevelstart=20 " ... every time
" space toggles current fold
nmap <space> za

" yank to system clipboard
map <leader>y "*y

" Don't move on *
nnoremap * *<c-o>

" Danish keyboards are different
map æ :
noremap - /
onoremap _ ^

" qq to record, Q to replay - uppercase Q is weird anyways
nnoremap Q @q

" I'm too fast for my own good
command! W :w
command! Wq :wq

" re-read current file from disk
nmap <F5> :e %<cr>

" toggle paste mode
set pastetoggle=<F6>

" git shortcuts
command! GP Git push
command! GU Git pull
command! GB !hub browse

" Multi-purpose tab-key
" Insert tab if beginning of line or after space, else do completion
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

" Function to strip trailing whitespace
fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun
map <leader>S :call <SID>StripTrailingWhitespaces()<cr>

" Map ,e to open files in the same directory as the current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%

" Easy window navigation
noremap <C-h>  <C-w>h
noremap <C-j>  <C-w>j
noremap <C-k>  <C-w>k
noremap <C-l>  <C-w>l

" Allow . to execute once for each line of a visual selection
vnoremap . :normal .<CR>

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

" file type specifics
augroup vimrcEx
  autocmd!

  " File types
  au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,Sitefile,Podfile,config.ru,*.thor} set ft=ruby
  au BufRead,BufNewFile *.{markdown,mdown,md} set ft=markdown

  " Foldmethod
  au BufNewFile,BufReadPost *.{coffee,rb} setlocal foldmethod=indent

  " mark Jekyll YAML frontmatter as comment
  au BufNewFile,BufRead *.{md,markdown,html,xml} sy match Comment /\%^---\_.\{-}---$/

  " magic markers: enable using `H/S/J/C to jump back to
  " last HTML, stylesheet, JS or Ruby code buffer
  au BufLeave *.{erb,html,haml,slim}  exe "normal! mH"
  au BufLeave *.{css,scss,sass}       exe "normal! mS"
  au BufLeave *.{js,coffee}           exe "normal! mJ"
  au BufLeave *.{rb}                  exe "normal! mC"
augroup END

" Plugins

" NERDCommenter
let g:NERDCreateDefaultMappings=0
let g:NERDSpaceDelims=1
map <leader>c <Plug>NERDCommenterToggle
" CtrlP
noremap <leader>f :CtrlP<cr>
" noremap <leader>F :CtrlP %%<cr>
" Map keys to go to specific files
noremap <leader>ga :CtrlP app/assets<cr>
noremap <leader>gc :CtrlP app/controllers<cr>
noremap <leader>gh :CtrlP app/helpers<cr>
noremap <leader>gv :CtrlP app/views<cr>
noremap <leader>gm :CtrlP app/models<cr>
noremap <leader>gp :CtrlP public<cr>
noremap <leader>gt :CtrlP test<cr>
noremap <leader>gr :topleft :split config/routes.rb<cr>
noremap <leader>gg :topleft :split Gemfile<cr>
" seoul256 theme
" let g:seoul256_background = 235

" Local config
if filereadable(expand("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif

map <leader>w :Bdelete<cr>

nmap ø <Plug>VinegarUp
