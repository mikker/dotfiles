" Looks
set guioptions-=T " No toolbar

" Font
if has('mac')
  set guifont=Menlo:h12
elseif has('unix')
  set guifont=Droid\ Sans\ Mono\ 10
endif

if has("gui_macvim")
  " Fullscreen takes up entire screen
  set fuoptions=maxhorz,maxvert

  " Command-t is cmd+l
  " macmenu &Tools.List\ Errors key=<nop>
  " map <D-l> :CommandT<CR>
  " imap <D-l> <esc>:CommandT<CR>

  " Command-Shift-F for Ack
  " macmenu Window.Toggle\ Full\ Screen\ Mode key=<nop>
  " map <D-F> :Ack<space>

  " Unbind <C-D>up|down
  " macmenu Tools.Older\ List key=<nop>
  " macmenu Tools.Newer\ List key=<nop>
endif

" Include user's local vim config
if filereadable(expand("~/.gvimrc.local"))
  source ~/.gvimrc.local
endif
