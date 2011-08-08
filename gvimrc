" No toolbar
set guioptions-=T

" Command-T
if has("gui_macvim")
  " Fullscreen takes up entire screen
  set fuoptions=maxhorz,maxvert

  " Command-t is cmd+l
  macmenu &Tools.List\ Errors key=<nop>
  map <D-l> :CommandT<CR>

  " Font settings
  set guifont=Liberation\ Mono:h14
  colorscheme sunburst
endif

" Command-T
autocmd FocusGained * call s:CmdTFlush()

" Flush Command-T on focus function
" function s:CmdTFlush(...)
  " let stay = 0

  " if(exists("a:1"))
    " let stay = a:1
  " end

  " if exists(":CommandTFlush") == 2
    " CommandTFlush
  " endif
" endfunction

" Include user's local vim config
if filereadable(expand("~/.gvimrc.local"))
  source ~/.gvimrc.local
endif
