" Looks
set guioptions-=T " No toolbar
set fuoptions=maxhorz,maxvert " Fullscreen takes up entire screen
set guifont=Menlo:h14 " Font
colorscheme Tomorrow-Night

if has("gui_macvim")
  " Command-t is cmd+l
  macmenu &Tools.List\ Errors key=<nop>
  map <D-l> :CommandT<CR>
  imap <D-l> <esc>:CommandT<CR>

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
