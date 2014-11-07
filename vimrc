" vim: fdm=marker foldlevel=0
set nocompatible

let g:plugins_file_path = "~/.vim/plugins.vim"

if filereadable(expand(g:plugins_file_path))
  exe ":source " . g:plugins_file_path
endif

filetype plugin indent on

com! EPlugs exe ":vsplit " . g:plugins_file_path
au! BufWritePost g:plugins_file_path exe "source %"

let mapleader=","

" {{{ Basics

set sh=/bin/bash

set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,/var/tmp,/tmp
if exists("+undofile")
  set undofile
  set undodir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
endif

set mouse=nvi " enable mouse in normal mode
set cursorline " highlight current line
set hidden " allow buffers in background
set number " line numbers
set listchars=tab:»·,trail:· " invisible chars
set list

set wildmode=longest:list,full

set ignorecase smartcase " search is case insensitive unless you use upper case
set gdefault " global search by default; /g for first-per-row only.
set nohlsearch " highlight results

set expandtab " spaces for tabs
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent

set laststatus=2

set switchbuf=useopen

set statusline=
set statusline+=\ %<%f    " relative path
set statusline+=%m        " modified flag
set statusline+=%=        " flexible space
set statusline+=%{fugitive#statusline()} " git
set statusline+=\ %{&ft}\   " filetype

set history=1000
set undolevels=1000

set foldlevel=999 " folds come expanded

let g:solarized_termcolors=256
let g:seoul256_background = 235

set background=dark
colorscheme xoria256

set autoread

set exrc " auto load local .vimrc files
set secure " but lets keep it secure

" }}}
" {{{ Mappings

noremap <c-_> :set hlsearch!<cr>

" jumping
nnoremap <leader><leader> <c-^>
nnoremap <PageUp> :bp<cr>
nnoremap <PageDown> :bn<cr>

" space toggles current fold
nnoremap <space> za
" yank to system clipboard
vnoremap <leader>y "*y
" Don't move on *
nnoremap * *<c-o>

" qq to record, Q to replay
nmap Q @q
vmap Q :normal Q<cr>

" %% Expands to dir of current file in cmd mode
cmap %% <C-R>=expand('%:h').'/'<cr>
" Map <leader>e to open files in the same directory as the current file
nmap <leader>e :edit %%

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
noremap ' `

" Indenting visual selection keeps selection
vnoremap < <gv
vnoremap > >gv

" This one's a thing - open current file in Quicksilver
noremap <leader>q :call system("qs ".expand("%"))<cr>

" I SAID CLOSE THAT WINDOW
nnoremap <silent> <c-w>z :wincmd z<bar>cclose<bar>lclose<cr>

noremap ¬ :set foldlevel=9999<cr>
noremap ˙ :set foldlevel=<c-r>=foldlevel(line('.'))-1<cr><cr>

noremap <leader>q :silent bufdo bd<cr>
noremap <leader>c :call system('ctags . -R')<cr>
noremap <c-w><c-t> :tabn<cr>

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

" search and replace
fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun
noremap <leader>S :call <SID>StripTrailingWhitespaces()<cr>

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

" minimal silver search 'plugin'
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<SPACE>

let g:colorpicker_app = 'iTerm.app'

let g:UltiSnipsExpandTrigger="<c-@>"
let g:UltiSnipsJumpForwardTrigger="<c-@>"
" let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"

command! GP Git push
command! GB Gbrowse

" }}}

fun! s:set_mark(args)
  let l:focus = expand(a:args)
  if l:focus != ""
    let g:focus=l:focus
  endif
  echo "Focus: ".g:focus.""
endfun

fun! s:run_mark()
  if !exists("g:focus")
    echo "No focus set yet"
  else
    execute g:focus
  endif
endfun

command! -nargs=* -complete=command Mark call s:set_mark(<q-args>)
command! -nargs=0 RunMark call s:run_mark()

augroup mapCREx
  au!
  " Leave the return key alone when in command line windows, since it's used
  " to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()
  autocmd! FileType qf nnoremap <buffer> <cr> <cr>
augroup END

fun! MapCR()
  noremap <cr> :RunMark<cr>
endfun
call MapCR()

noremap <leader>mc :silent Mark call system('reload-chrome')<cr>
noremap <leader>ml :silent Mark !rspec <c-r>=expand('%').':'.line('.')<cr><cr>
noremap <leader>mf :silent Mark !rspec <c-r>=expand('%')<cr><cr>

noremap <leader>A :!rspec<cr>
noremap <leader>F :!rspec spec/features<cr>
noremap <leader>U :!rspec spec/^(features\|*\.*)<cr>

" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

