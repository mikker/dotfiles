" vim: fdm=marker foldlevel=0
set nocompatible

if filereadable(expand("~/.vim/bundles.vim"))
  source ~/.vim/bundles.vim
endif

filetype plugin indent on

" {{{ Basics

set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
if exists("+undofile")
  set undofile
  set undodir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
endif

set mouse=nvi " enable mouse

set cursorline " highlight current line
set hidden " allow buffers in background
set number " line numbers

set listchars=tab:»·,trail:· " invisible chars

set wildmode=longest:list,full

set ignorecase " search is case insensitive
set smartcase " ... unless you use upper case
set gdefault " global search by default; /g for first-per-row only.
set hlsearch " highlight results

set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent

set statusline=
set statusline+=\ %<%f    " relative path
set statusline+=%m        " modified flag
set statusline+=%=        " flexible space
set statusline+=%{fugitive#statusline()} " git
set statusline+=%{&ft}\   " filetype

set history=10000
set undolevels=10000

set foldlevel=9

colorscheme apprentice

" }}}
" {{{ Mappings

nmap <c-_> :nohl<cr>

" jumping
nmap <leader><leader> <c-^>
nmap <PageUp> :bp<cr>
nmap <PageDown> :bn<cr>

omap _ ^

" space toggles current fold
nmap <space> za
" yank to system clipboard
vmap <leader>y "*y
" Don't move on *
nnoremap * *<c-o>

" qq to record, Q to replay
nnoremap Q @q
vnoremap Q :normal Q<cr>

" Open splits at top level
map <c-w>V :botright :vertical :split<cr>
map <c-w>S :topleft :split<cr>

" Map ,e to open files in the same directory as the current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%

" visual moving
noremap k gk
noremap j gj

" Easy window navigation
noremap <C-h>  <C-w>h
noremap <C-j>  <C-w>j
noremap <C-k>  <C-w>k
noremap <C-l>  <C-w>l

" Y behaves like other capital letters
nnoremap Y y$

" always jump to char (and not just line)
map ' `

" Indenting visual selection keeps selection
vnoremap < <gv
vnoremap > >gv

" This one's a thing - open current file in Quicksilver
map ,q :call system("qs ".expand("%"))<cr>

" }}}
" {{{ Functions and commands

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

" Rename current file
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent call system("rm ' . old_name . '")'
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>

" }}}
" {{{ Autocommands
augroup vimrcEx
  autocmd!

  " Auto-open quickfix window after grep cmds
  autocmd QuickFixCmdPost *grep* cwindow

  " YAML front-matter
  au BufNewFile,BufRead *.{md,markdown,html,xml,erb} sy match Comment /\%^---\_.\{-}---$/

  " magic markers: enable using `H/S/J/C to jump back to
  " last HTML, stylesheet, JS or Ruby code buffer
  au BufLeave *.{erb,html,haml,slim}  exe "normal! mH"
  au BufLeave *.{css,scss,sass}       exe "normal! mS"
  au BufLeave *.{js,coffee}           exe "normal! mJ"
  au BufLeave *.{rb}                  exe "normal! mC"
augroup END

" syntax scope of the current char
fun! SyntaxScope()
  echo map(synstack(line('.'), col('.')),'synIDattr(v:val, "name")')
endfun
com! SyntaxScope call SyntaxScope()

com! RE call system("touch tmp/restart.txt")

" }}}
" Plugin config and maps {{{

" CtrlP
noremap <leader>f :CtrlP<cr>
" Map keys to go to specific files
noremap <leader>ga :CtrlP app/assets<cr>
noremap <leader>gc :CtrlP app/controllers<cr>
noremap <leader>gh :CtrlP app/helpers<cr>
noremap <leader>gv :CtrlP app/views<cr>
noremap <leader>gm :CtrlP app/models<cr>
noremap <leader>gp :CtrlP public<cr>
noremap <leader>gt :CtrlP test<cr>
noremap <leader>gs :CtrlP spec<cr>
noremap <leader>gr :topleft :split config/routes.rb<cr>
noremap <leader>gg :topleft :split Gemfile<cr>
noremap <leader>b :CtrlPBuffer<cr>

let g:ctrlp_max_height = 20
let g:ctrlp_show_hidden = 0
let g:ctrlp_max_files = 0
let g:ctrlp_switch_buffer = 0
let g:ctrlp_use_caching = 2000

" ag for ack
" brew install the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

let g:colorpicker_app = 'iTerm.app'

nmap <leader>r :Dispatch<cr>

" }}}

" Add quickfix-files to args
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
" populate the argument list with each of the files named in the quickfix list
function! QuickfixFilenames()
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

set autoread

set exrc " auto load local .vimrc files
set secure " but lets keep it secure

imap <c-e> <c-o>ve

" apprentice theme
" hi link rubySymbol Type
