" Looks
set guioptions-=T " No toolbar

" Font
if has('mac')
  set guifont=Liberation\ Mono:h19
elseif has('unix')
  set guifont=Droid\ Sans\ Mono\ 10
endif

if has("gui_macvim")
  " Fullscreen takes up entire screen
  set fuoptions=maxhorz,maxvert
endif

" Include user's local vim config
if filereadable(expand("~/.gvimrc.local"))
  source ~/.gvimrc.local
endif

