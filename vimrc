set nocompatible

set nobackup
set nowritebackup
set noswapfile

set ruler
set showcmd
set laststatus=2

" Allow mouse in terminal vim
set ttymouse=xterm2
set mouse=a

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

" Completion
set wildmenu
set wildmode=list:longest

" Use The Silver Searcher
" https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  " ack.vim searches with ag
  let g:ackprg = 'ag --nogroup --nocolor --column'
endif

" Search
set incsearch
set ignorecase " search is case insensitive
set smartcase " ... unless you use upper case
set gdefault " global search by default; /g for first-per-row only.
set hlsearch " highlight results

" Color scheme
colorscheme seoul256

" Line numbers
set number
set numberwidth=5

" Windows
" set winwidth=84
set winheight=3
set winminheight=3
set winheight=999

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

" qq to record, Q to replay - uppercase Q is weird anyways
nnoremap Q @q

" I'm too fast for my own good
command! W :w

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

fun! Z(cmd)
  echom system("zsh -c " . a:cmd)
endfun

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
" autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
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

" ,cf to go to nonexisting gf file
map <leader>gf :e <cfile><cr>

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
noremap <leader>gt :CtrlP test<cr>
noremap <leader>gr :topleft :split config/routes.rb<cr>
noremap <leader>gg :topleft 100 :split Gemfile<cr>
" Airline
let g:airline_powerline_fonts = 1
let g:airline_theme = 'ubaryd'
let g:airline_section_warning = ''
" AirlineTheme ubaryd
" Yankstack without meta-key on DK mac keyboard
let g:yankstack_map_keys = 0
nmap ∏ <Plug>yankstack_substitute_newer_paste
nmap π <Plug>yankstack_substitute_older_paste
imap ∏ <Plug>yankstack_substitute_newer_paste
imap π <Plug>yankstack_substitute_older_paste
" seoul256 theme
let g:seoul256_background = 234

" Local config
if filereadable(expand("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif

map <leader>T :TagbarToggle<cr>

set foldmethod=syntax " fold by syntax
set foldlevel=20 " folds come expanded
set foldlevelstart=20 " ... every time

" yank to system clipboard
map <leader>y "*y

augroup vimrcEx
  autocmd!

  " File types
  au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,Sitefile,Podfile,config.ru,*.thor} set ft=ruby
  au BufRead,BufNewFile *.{markdown,mdown,md} set ft=markdown
  au BufNewFile,BufReadPost *.coffee setl foldmethod=indent

  au FileType gitcommit setlocal winheight=18 
  au FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

  " mark Jekyll YAML frontmatter as comment
  au BufNewFile,BufRead *.{md,markdown,html,xml} sy match Comment /\%^---\_.\{-}---$/

  " magic markers: enable using `H/S/J/C to jump back to
  " last HTML, stylesheet, JS or Ruby code buffer
  au BufLeave *.{erb,html}      exe "normal! mH"
  au BufLeave *.{css,scss,sass} exe "normal! mS"
  au BufLeave *.{js,coffee}     exe "normal! mJ"
  au BufLeave *.{rb}            exe "normal! mC"

augroup END

set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

command! GP Git push
command! GU Git pull
command! GB !hub browse

inoremap <F6> <C-o>:set paste!<cr>
