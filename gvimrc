" No toolbar
set guioptions-=T
" Fullscreen takes up entire screen
set fuoptions=maxhorz,maxvert
" Font settings
set guifont=Menlo:h12
colorscheme Tomorrow-Night

" Compliments of TextMate
" Hash rocket (ctrl+l)
imap <C-L> <space>=><space>
" Open new line below (cmd+enter)
imap <D-CR> <ESC>o
map <D-CR> o
" Deselect highlighted search terms
map <D-d> :nohl<CR>
imap <D-d> <Esc>:nohl<CR>a
" Toggle hidden characters
map <C-h> :set list!<CR>

" Windows
map <M-D-Left> <C-w>h
map <M-D-Right> <C-w>l
map <M-D-Up> <C-w>k
map <M-D-Down> <C-w>j
" Buffers
map <S-D-Left> :bp!<CR>
map <S-D-Right> :bn!<CR>
map <S-D-BS> :bd!<CR>

if has("gui_macvim")
  " Command-t is cmd+l
  macmenu &Tools.List\ Errors key=<nop>
  map <D-l> :CommandT<CR>
  imap <D-l> <Esc>:CommandT<CR>

  " Command-Shift-F for Ack
  macmenu Window.Toggle\ Full\ Screen\ Mode key=<nop>
  map <D-F> :Ack<space>
  macmenu Tools.Older\ List key=<nop>
  macmenu Tools.Newer\ List key=<nop>
endif

" Include user's local vim config
if filereadable(expand("~/.gvimrc.local"))
  source ~/.gvimrc.local
endif

" Moving lines around (using vim-unimpaired)
" http://github.com/tpope/vim-unimpaired
map <C-D-Up> [e
map <C-D-Down> ]e
vmap <C-D-Up> [egv
vmap <C-D-Down> ]egv
" Reselect last visual selection
nmap gV `[v`]
