set nocompatible
""""""""""""""""""""""""""
"   Personal vim config  "
"     Mikkel Malmberg    "
"                        "
""""""""""""""""""""""""""
set encoding=utf-8

" Setup paths using pathogen
filetype off
call pathogen#runtime_append_all_bundles()
" call pathogen#helptags()

" { GENERAL }

filetype plugin indent on
syntax on
color desert
set shell=sh " zsh doesn't work so well
set ruler

" Indentation
set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab
set autoindent
set smarttab
set cindent
set autoread
set gdefault    " Global search by default; /g for first-per-row only.

" Preferred file formats
set fileformat=unix
set fileformats=unix,dos,mac

" Tab completion
set wildmode=longest,list
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

" No backup files
set backupdir=$HOME/.vim/backup
set directory=$HOME/.vim/backup

" { LOOKS }

" Colorscheme

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

" Colon is tricky on danish keyboards
map æ :

" Leader
let mapleader = ","

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

" " { OTHER }

" " Automatically strip trailing whitespace
fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

map <C-D-w> :call Wipeout()<CR>

" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,Sitefile,config.ru} set ft=ruby
au BufRead,BufNewFile {*.markdown,*.md} set ft=markdown

" Source a global configuration file if available
if filereadable(expand("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif

" Quicker filetype setting:
"   :F html
" instead of
"   :set ft=html
" Can tab-complete filetype.
command! -nargs=1 -complete=filetype F set filetype=<args>

" Even quicker setting often-used filetypes.
command! FR set filetype=ruby


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

" Seriously, guys. It's not like :W is bound to anything anyway.
command! W :w

" Map keys to go to specific files
map <leader>ga :CommandTFlush<cr>\|:CommandT app/assets<cr>
map <leader>gc :CommandTFlush<cr>\|:CommandT app/controllers<cr>
map <leader>gh :CommandTFlush<cr>\|:CommandT app/helpers<cr>
map <leader>gv :CommandTFlush<cr>\|:CommandT app/views<cr>
map <leader>gm :CommandTFlush<cr>\|:CommandT app/models<cr>
map <leader>gl :CommandTFlush<cr>\|:CommandT lib<cr>
map <leader>gp :CommandTFlush<cr>\|:CommandT public<cr>
map <leader>gr :topleft :split config/routes.rb<cr>
map <leader>gg :topleft 100 :split Gemfile<cr>
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
map <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>

" Jump around
nnoremap <leader><leader> <c-^>

"""""""""
" TESTS "
"""""""""
function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo
    if filereadable("script/test")
        exec ":!script/test " . a:filename
    else
        exec ":!bundle exec rspec " . a:filename
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
    let in_spec_file = match(expand("%"), '_spec.rb$') != -1
    if in_spec_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
endfunction

map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
" map <leader>a :call RunTests('spec')<cr>

set winwidth=84
" We have to have a winheight bigger than we want to set winminheight. But if
" we set winheight to be huge before winminheight, the winminheight set will
" fail.
set winheight=5
set winminheight=5
set winheight=999

nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
nnoremap <c-n> :let &wh = (&wh == 999 ? 10 : 999)<CR><C-W>=
map <c-Down> <c-j>
map <c-Up> <c-k>
map <c-Left> <c-h>
map <c-Right> <c-l>

" Hash rocket (ctrl+l)
imap <C-L> <space>=><space>
" Toggle hidden characters
" map <C-h> :set list!<CR>

