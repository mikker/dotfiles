" No toolbar
set guioptions-=T

" Compliments of TextMate
" Hash rocket (ctrl+l)
imap <C-L> <space>=><space>
" Open new line below (cmd+enter)
imap <D-CR> <ESC>o
map <D-CR> o
" Deselect highlighted search terms
map <D-d> :nohl<CR>
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


" Command-T
if has("gui_macvim")
  " Fullscreen takes up entire screen
  set fuoptions=maxhorz,maxvert

  " Command-t is cmd+l
  macmenu &Tools.List\ Errors key=<nop>
  map <D-l> :CommandT<CR>

  " Command-Shift-F for Ack
  macmenu Window.Toggle\ Full\ Screen\ Mode key=<nop>
  map <D-F> :Ack<space>

  " Font settings
  set guifont=Liberation\ Mono:h14
  colorscheme sunburst
endif

" Flush Command-T on focus function
function s:CmdTFlush(...)
  let stay = 0

  if(exists("a:1"))
    let stay = a:1
  end

  if exists(":CommandTFlush") == 2
    CommandTFlush
  endif
endfunction

" Command-T
autocmd FocusGained * call s:CmdTFlush()

" Include user's local vim config
if filereadable(expand("~/.gvimrc.local"))
  source ~/.gvimrc.local
endif
