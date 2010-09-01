" No toolbar
set guioptions-=T

" Command-T
if has("gui_macvim")
  macmenu &Tools.List\ Errors key=<nop>
  " macmenu &File.New\ Tab key=<nop>
  map <D-l> :CommandT<CR>
endif
