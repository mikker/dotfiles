" vim: fdm=marker foldlevel=0
set nocompatible

" {{{ Plugins

let g:plugins_file_path = "~/.vim/plugins.vim"

if filereadable(expand(g:plugins_file_path))
  exe ":source " . g:plugins_file_path
endif

filetype plugin indent on

com! EPlugs exe ":vsplit " . g:plugins_file_path

" }}}
" {{{ Basics

set shell=zsh

" no regrets
set nobackup
set noswapfile
set directory=~/.vim-tmp,~/.tmp,/var/tmp,/tmp
if exists("+undofile")
  set undofile
  set undodir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
endif

set hidden " allow backgrounding edited buffers

set mouse=nvi " enable mouse in normal mode
set cursorline " highlight current line
set hidden " allow buffers in background
set number " line numbers
set listchars=tab:»·,trail:· " invisible chars
set list " show tabs and trailing whitespace

set wildmode=longest:list,full " tab completion
set laststatus=2 " always show status bar

set ignorecase smartcase " search is case insensitive unless you use upper case
set gdefault " global search by default; /g for first-per-row only.

set autoindent " indent to current depth on new lines
set expandtab " spaces for tabs
set tabstop=2
set shiftwidth=2
set softtabstop=2

set switchbuf=usetab " switch to existing buffer if there is one
set autoread " update files when coming back

set history=1000 " more history
set undolevels=1000 " more undolevels

set statusline=
set statusline+=\ %<%f    " relative path
set statusline+=%m        " modified flag
set statusline+=%=        " flexible space
set statusline+=%{fugitive#statusline()} " git
set statusline+=\ %{&ft}\   " filetype

set foldlevel=999 " folds come expanded

set exrc " auto load local .vimrc files
set secure " but lets keep it secure

" }}}
" {{{ Mappings

let mapleader="\<Space>"

noremap <c-_> :set hlsearch!<cr>

" jumping
nnoremap <leader><leader> <c-^>

" space toggles current fold
" nnoremap <space> za
" yank to system clipboard
vnoremap <leader>y "*y
" Don't move on *
nnoremap * *<c-o>

" qq to record, Q to replay
nmap Q @q
vmap Q :normal Q<cr>

" %% expands to dir of current file in cmd mode
cmap %% <C-R>=expand('%:h').'/'<cr>
" edit file in the same directory as the current file
nmap <leader>e :edit %%

" visual moving
noremap k gk
noremap j gj

" Easy window navigation
noremap <C-h>  <C-w>h
noremap <C-j>  <C-w>j
noremap <C-k>  <C-w>k
noremap <C-l>  <C-w>l

" cycle tab
noremap <c-w><c-t> :tabn<cr>

" Y behaves like other capital letters
nnoremap Y y$

" always jump to char (and not just line)
noremap ' `

" Indenting visual selection keeps selection
vnoremap < <gv
vnoremap > >gv

" Open cwd in Finder.app
nnoremap <leader>O :call system('open .')<cr>

" I SAID CLOSE THAT WINDOW
nnoremap <silent> <c-w>z :wincmd z<bar>cclose<bar>lclose<cr>

" poor mans meta key is to map unicode-chars
noremap ¬ :set foldlevel=9999<cr>
noremap ˙ :set foldlevel=<c-r>=foldlevel(line('.'))-1<cr><cr>

" git status and diff
nnoremap <f5> :Gst<cr>
" remove fluff
nnoremap <f10> :Goyo<cr>

" c-c in visual mode acts like <esc>
xnoremap <c-c> <esc>

" Readline-style key bindings in command-line
cnoremap        <C-A> <Home>
silent! exe "set <S-Left>=\<Esc>b"
silent! exe "set <S-Right>=\<Esc>f"

" }}}
" {{{ Functions and commands

" Multi-purpose tab-key
" Insert tab if beginning of line or after space, else do completion
" function! InsertTabWrapper()
"   let col = col('.') - 1
"   if !col || getline('.')[col - 1] !~ '\k'
"     return "\<tab>"
"   else
"     return "\<c-p>"
"   endif
" endfunction
" inoremap <tab> <c-r>=InsertTabWrapper()<cr>
" inoremap <s-tab> <c-n>
function! s:super_duper_tab(k, o)
  if pumvisible()
    return a:k
  endif

  let line = getline('.')
  let col = col('.') - 2
  if empty(line) || line[col] !~ '\k\|[/~.]' || line[col + 1] =~ '\k'
    return a:o
  endif

  let prefix = expand(matchstr(line[0:col], '\S*$'))
  if prefix =~ '^[~/.]'
    return "\<c-x>\<c-f>"
  endif
  if !empty(&completefunc) && call(&completefunc, [1, prefix]) >= 0
    return "\<c-x>\<c-u>"
  endif
  return a:k
endfunction

inoremap <expr> <tab>   <SID>super_duper_tab("\<c-n>", "\<tab>")
inoremap <expr> <s-tab> <SID>super_duper_tab("\<c-p>", "\<s-tab>")

" Quicker filetype setting:
"   :F html
command! -nargs=1 F set filetype=<args>
command! FR set filetype=ruby
command! FJ set filetype=javascript

" find and delete all trailing whitespace
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

" git shortcuts
command! -nargs=* GP Git push <args>
command! -nargs=* GU Git pull <args>
command! -nargs=* GB Gbrowse <args>

noremap <leader>mc :silent Rerun call system('reload-chrome')<cr>

" Rotate user-installed colorschemes with <f8>
function! s:rotate_colors()
  if !exists('s:colors_list')
    let s:colors_list =
    \ sort(map(
    \   filter(split(globpath(&rtp, "colors/*.vim"), "\n"), 'v:val !~ "^/usr/"'),
    \   "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"))
  endif
  if !exists('s:colors_index')
    let s:colors_index = index(s:colors_list, g:colors_name)
  endif
  let s:colors_index = (s:colors_index + 1) % len(s:colors_list)
  let name = s:colors_list[s:colors_index]
  execute 'colorscheme' name
  redraw
  echo name
endfunction
nnoremap <F8> :call <SID>rotate_colors()<cr>

" What is this syntax colored as?
function! s:hl()
  echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), '/')
endfunction
command! HL call <SID>hl()

" }}}
" {{{ Autocommands
augroup vimrcEx
  autocmd!

  " Auto-open quickfix window after grep cmds
  autocmd QuickFixCmdPost *grep* cwindow

  au BufNewFile,BufRead *.boot set ft=clojure
  au BufNewFile,BufRead TODO set ft=taskpaper

  " YAML front-matter
  au BufNewFile,BufRead *.{md,markdown,html,xml,erb} sy match Comment /\%^---\_.\{-}---$/

  " magic markers: enable using `H/S/J/C to jump back to
  " last HTML, stylesheet, JS or Ruby code buffer
  au BufLeave *.{erb,html,haml,slim}  exe "normal! mH"
  au BufLeave *.{css,scss,sass}       exe "normal! mS"
  au BufLeave *.{js,coffee}           exe "normal! mJ"
  au BufLeave *.{rb}                  exe "normal! mC"
augroup END

" }}}
" Plugin config and maps {{{

" FZF
noremap <leader>f :FZF<cr>
" Map keys to go to specific files
noremap <leader>ga :FZF app/assets<cr>
noremap <leader>gc :FZF app/controllers<cr>
noremap <leader>gh :FZF app/helpers<cr>
noremap <leader>gv :FZF app/views<cr>
noremap <leader>gm :FZF app/models<cr>
noremap <leader>gt :FZF test<cr>
noremap <leader>gs :FZF spec<cr>
noremap <leader>gr :topleft :split config/routes.rb<cr>
noremap <leader>gg :topleft :split Gemfile<cr>

" Ctrl-P
let g:ctrlp_use_caching = 0
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
endif

" ag for ack
" brew install the_silver_searcher
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
endif

" minimal silver search command
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<SPACE>

let g:task_paper_follow_move = 0

let g:syntastic_html_checkers=['']
let g:syntastic_javascript_checkers = ['standard']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_wq = 0
" (syntastic is only on for js)

" fzf buffers
function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

nnoremap <silent> <Leader>b :call fzf#run({
\   'source':  reverse(<sid>buflist()),
\   'sink':    function('<sid>bufopen'),
\   'options': '+m',
\   'down':    len(<sid>buflist()) + 2
\ })<CR>

" fzf tags
command! FZFTag if !empty(tagfiles()) | call fzf#run({
\   'source': "sed '/^\\!/d;s/\t.*//' " . join(tagfiles()) . ' | uniq',
\   'sink':   'tag',
\ }) | else | echo 'No tags' | endif
nnoremap <silent> <leader>t :FZFTag<cr>

" }}}

set background=dark
colorscheme PaperColor

xmap <cr> :EasyAlign<cr>

let g:UltiSnipsExpandTrigger       = "<c-l>"
let g:UltiSnipsListSnippets        = "<c-q>"
let g:UltiSnipsJumpForwardTrigger  = "<c-n>"
let g:UltiSnipsJumpBackwardTrigger = "<c-p>"

let g:user_emmet_leader_key='<c-e>'

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

nmap <leader>w :w<cr>

fun! s:openMarked()
  call system('open -a Marked\ 2 "' . expand("%") . '"')
endfun
command! Marked call s:openMarked()

