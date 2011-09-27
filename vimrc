set nocompatible
""""""""""""""""""""""""""
"   Personal vim config  "
"     Mikkel Malmberg    "
"                        "
""""""""""""""""""""""""""
set encoding=utf-8 " ensure encoding

" Setup paths and help tags from pathogen
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" { GENERAL }

filetype plugin indent on " enable filetype and it's plugins
syntax on " syntax highlighting on

set shell=sh " zsh doesn't work so well
set ruler " enable ruler
set gdefault " Global search by default; /g for first-per-row only.
set backspace=indent,eol,start "  backspace over everything in insert mode

" Indentation
set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab
set autoindent
set smarttab
set cindent
set autoread

" Preferred file formats
set fileformat=unix
set fileformats=unix,dos,mac

" Tab completion
set wildmode=longest,list
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,test/fixtures/*,vendor/gems/*

" Search
set incsearch
set hlsearch
set ignorecase
set smartcase

" Centralized backup files
set backupdir=$HOME/.vim/backup
set directory=$HOME/.vim/backup

" { LOOKS }

color Tomorrow-Night " https://github.com/ChrisKempson/Tomorrow-Theme

set showtabline=1 " only show tabbar when > 1 tab
" Command
set cmdheight=1
set laststatus=2
set statusline=%F%m%r%h%w\ (%Y)[%v]
" Line numbers
set numberwidth=2
set number
" Windows
set winwidth=84
" We have to have a winheight bigger than we want to set winminheight. But if
" we set winheight to be huge before winminheight, the winminheight set will
" fail.
set winheight=5
set winminheight=5
set winheight=999

" { MAPPINGS }

" Leader
let mapleader = ","

" Open new line below (cmd+enter)
imap <D-CR> <esc>o
map <D-CR> o

" Deselect highlighted search terms
map <D-d> :nohl<CR>
imap <D-d> <esc>:nohl<CR>gi

" Close current buffer
map <S-D-BS> :bd!<CR>

" Hash rocket (ctrl+l)
imap <C-l> <space>=><space>
" Toggle hidden characters
map <leader>h :set list!<cr>

" Moving lines around (using vim-unimpaired)
" http://github.com/tpope/vim-unimpaired
map <C-D-Up> [e
map <C-D-Down> ]e
vmap <C-D-Up> [egv
vmap <C-D-Down> ]egv

" Reselect last visual selection
nmap gV `[v`]

" Move by screen lines instead of file lines.
" http://vim.wikia.com/wiki/Moving_by_screen_lines_instead_of_file_lines
" noremap <Up> gk
" noremap <Down> gj
" noremap k gk
" noremap j gj
" inoremap <Down> <C-o>gj
" inoremap <Up> <C-o>gk

" Make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv

" I do this ALL the time
command! W :w
" Colon is tricky on danish keyboards
map æ :

" Readjust windows
nnoremap <c-n> :let &wh = (&wh == 999 ? 10 : 999)<CR><C-W>=
" Jump around
map <D-A-down> <c-w>j
map <D-A-up> <c-w>k
map <D-A-left> <c-w>h
map <D-A-right> <c-w>l
" Open a the split rightmost in the window
map <c-w>V :botright :vertical :split<cr>

" quickly jump between two recent files
nnoremap <leader><leader> <c-^>

" { PLUGINS }

" NERDTree
" let loaded_nerd_tree=1
map <Leader>d :NERDTreeToggle<CR>
let g:NERDTreeWinPos="right"
let g:NERDMenuMode=0
" let g:NERDTreeWinSize=24

" NERDCommenter
let g:NERDCreateDefaultMappings=0
let g:NERDSpaceDelims=1
map <leader>c <Plug>NERDCommenterToggle

" snipMate
nmap <Leader>rr :call ReloadAllSnippets()<CR>

" { FILETYPES }

" Quicker filetype setting:
"   :F html
" instead of
"   :set ft=html
command! -nargs=1 F set filetype=<args>
" Even quicker setting often-used filetypes.
command! FR set filetype=ruby

" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,Sitefile,config.ru} set ft=ruby
au BufRead,BufNewFile {*.markdown,*.md} set ft=markdown

" { OTHER }

" Automatically strip trailing whitespace
fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Source a global configuration file if available
if filereadable(expand("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif

" ------ "
" FROM https://github.com/garybernhardt/dotfiles/blob/master/.vimrc

" Map ,e and ,v to open files in the same directory as the current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%
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

" Map keys to go to specific files
noremap <leader>ga :CommandTFlush<cr>\|:CommandT app/assets<cr>
noremap <leader>gc :CommandTFlush<cr>\|:CommandT app/controllers<cr>
noremap <leader>gh :CommandTFlush<cr>\|:CommandT app/helpers<cr>
noremap <leader>gv :CommandTFlush<cr>\|:CommandT app/views<cr>
noremap <leader>gm :CommandTFlush<cr>\|:CommandT app/models<cr>
noremap <leader>gl :CommandTFlush<cr>\|:CommandT lib<cr>
noremap <leader>gp :CommandTFlush<cr>\|:CommandT public<cr>
noremap <leader>gr :topleft :split config/routes.rb<cr>
noremap <leader>gg :topleft 100 :split Gemfile<cr>
noremap <leader>f :CommandTFlush<cr>\|:CommandT<cr>
noremap <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>

"""""""""
" TESTS "
"""""""""
function! RunTests(filename)
  " Write the file and run tests for the given filename
  :w
  :silent !echo;echo;echo;echo;echo
  if filereadable("script/test")
    exec ":!script/test " . a:filename
  elseif filereadable("spec/spec_helper.rb")
    exec ":!spec " . a:filename
  else
    exec ":!rake test:single TEST=" . a:filename
  end
endfunction

function! SetTestFile()
  " Set the spec file that tests will be run for.
  let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
  if a:0
    let command_suffix = a:1
  else
    let command_suffix = ""
  endif

  " Run the tests for the previously-marked file.
  let in_spec_file = match(expand("%"), '_(test|spec).rb$') != -1
  if in_spec_file
    :!echo "in spec!"
    call SetTestFile()
  elseif !exists("t:grb_test_file")
    return
  end
  call RunTests(t:grb_test_file . command_suffix)
endfunction

" function! RunNearestTest()
  " let spec_line_number = line('.')
  " call RunTestFile(":" . spec_line_number)
" endfunction

map <leader>t :call RunTestFile()<cr>
" map <leader>T :call RunNearestTest()<cr>
map <leader>S :call RunTests('spec')<cr>
map <leader>T :call RunTests('test')<cr>
