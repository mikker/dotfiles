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

" { GENERAL }

set nocompatible " get with the times
set modelines=0 " security thing?
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
set scrolloff=3 " some pading around search results
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
set cursorline " highlight current line
set hidden " allow buffers in background

" Search
nnoremap / /\v
vnoremap / /\v
set ignorecase " search is case insensitive
set smartcase " ... unless you use upper case
set gdefault " global search by default; /g for first-per-row only.
set incsearch " incremental search
set hlsearch " highlight results
" nnoremap <tab> %
" vnoremap <tab> %

" Centralized backup files
set backupdir=$HOME/.vim/backup,/var/tmp,/tmp
set directory=$HOME/.vim/backup,/var/tmp,/tmp

" { LOOKS }

syntax on
colorscheme jellybeans " https://github.com/ChrisKempson/Tomorrow-Theme
set listchars=tab:▸\ ,eol:¬
nnoremap <c-h> :set list!<cr>

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
set winheight=3
set winminheight=3
set winheight=999

" { MAPPINGS }

" Leader
let mapleader = ","

" Set system clipboard contents as register
map <leader>y "*y

" Open new line below (cmd+enter)
imap <D-CR> <esc>o
map <D-CR> o

" Deselect highlighted search terms
" map <D-d> :nohl<CR>
imap <D-d> <esc>:nohl<CR>gi
map <cr> :nohl<cr>

" Let's see how long this goes...
" map <Left> :echo "no!"<cr>
" map <Right> :echo "no!"<cr>
" map <Up> :echo "no!"<cr>
" map <Down> :echo "no!"<cr>

" Hash rocket (ctrl+l)
imap <C-l> <space>=><space>
" Toggle hidden characters
map <leader>h :set list!<cr>

" Reselect last visual selection
nmap gV `[v`]

" Move by screen lines instead of file lines.
" http://vim.wikia.com/wiki/Moving_by_screen_lines_instead_of_file_lines
noremap <Up> gk
noremap <Down> gj
noremap k gk
noremap j gj
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" Make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv

" I do this ALL the time
command! W :w
" Colon is tricky on danish keyboards
map æ :
nnoremap å {
nnoremap ¨ }
onoremap å {
onoremap ¨ }

noremap - /\v
vnoremap - /\v
noremap _ ^
onoremap _ ^

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

" Readjust windows
nnoremap <c-n> :let &wh = (&wh == 999 ? 10 : 999)<CR><C-W>=
" Jump around
" noremap <D-A-down> <c-w>j
" noremap <D-A-up> <c-w>k
" noremap <D-A-left> <c-w>h
" noremap <D-A-right> <c-w>l
" Open a the split rightmost in the window
map <c-w>V :botright :vertical :split<cr>
map <c-w>S :topleft :split<cr>

" quickly jump between two recent files
nnoremap <leader><leader> <c-^>

" { PLUGINS }

" NERDCommenter
let g:NERDCreateDefaultMappings=0
let g:NERDSpaceDelims=1
map <leader>c <Plug>NERDCommenterToggle
" snipMate
nmap <Leader>rr :call ReloadAllSnippets()<CR>
" GundoTree
nnoremap <F5> :GundoToggle<CR>

" { FILETYPES }

" Quicker filetype setting:
"   :F html
" instead of
"   :set ft=html
command! -nargs=1 F set filetype=<args>
" Even quicker setting often-used filetypes.
command! FR set filetype=ruby

" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,Sitefile,Podfile,config.ru} set ft=ruby
au BufRead,BufNewFile {*.markdown,*.md} set ft=markdown

" { OTHER }

" Automatically strip trailing whitespace
fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun
" autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
map <leader>S :call <SID>StripTrailingWhitespaces()<cr>

" Map ,e and ,v to open files in the same directory as the current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
" map <leader>v :view %%

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
noremap <leader>gf :topleft 100 :split test/factories.rb<cr>
noremap <leader>f :CommandTFlush<cr>\|:CommandT<cr>
noremap <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>

" Quick calculations
inoremap <C-A> <C-O>yiW<End>=<C-R>=<C-R>0<CR><esc>F=i<space><esc>la<space><esc>A

"" NEW STUFF

" Don't move on *
nnoremap * *<c-o>

" Easy buffer navigation
noremap <C-h>  <C-w>h
noremap <C-j>  <C-w>j
noremap <C-k>  <C-w>k
noremap <C-l>  <C-w>l

" allow the . to execute once for each line of a visual selection
vnoremap . :normal .<CR>

" Source a global configuration file if available
if filereadable(expand("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif


" Close current buffer
" map <S-D-BS> :bd!<CR>

" Moving lines around (using vim-unimpaired)
" http://github.com/tpope/vim-unimpaired
" map <C-D-Up> [e
" map <C-D-Down> ]e
" vmap <C-D-Up> [egv
" vmap <C-D-Down> ]egv
