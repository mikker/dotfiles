
" TT runs a terminal command in a new tab before the current one
"   :TT [terminal command]
fun! s:runTermInTab(args)
  if tabpagenr() > 1
  else
    execute '-tabnew|term ' . expand(a:args)
    keepalt file TT
    normal i
  endif
endfun
command! -nargs=* -complete=file TT call s:runTermInTab(<q-args>)

" Open current file in Marked.app
command! Marked call system('open -a Marked\ 2 "'.expand('%').'"')

" Quicker filetype setting:
"   :F html
command! -nargs=1 F set filetype=<args>

" find and delete all trailing whitespace
fun! <SID>StripTrailingWhitespaces()
  let l:l = line('.')
  let l:c = col('.')
  %s/\s\+$//e
  call cursor(l:l, l:c)
endfun
noremap <leader>S :call <SID>StripTrailingWhitespaces()<cr>

augroup vimrcEx
  autocmd!

  " Auto-open quickfix window after grep cmds
  autocmd QuickFixCmdPost *grep* cwindow

  " magic markers: enable using `H/S/J/C to jump back to
  " last HTML, stylesheet, JS or app code buffer
  au BufLeave *.{erb,html,haml,slim,eex} exe "normal! mH"
  au BufLeave *.{css,scss}               exe "normal! mS"
  au BufLeave *.{js,jsx,ts,tsx}          exe "normal! mJ"
  au BufLeave *.{rb,ex,exs}              exe "normal! mC"
  au BufLeave *.yml                      exe "normal! mY"

  " Resize windows when the terminal window size changes (from http://vimrcfu.com/snippet/186)
  autocmd VimResized * wincmd =

  " Don't auto insert a comment when using O/o for a newline
  autocmd VimEnter,BufRead,FileType * set formatoptions-=o

  " Automatically reload files when changed
  autocmd FocusGained, BufEnter * :checktime
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
        \ if mode() == 'n' && getcmdwintype() == '' | checktime | endif
augroup END

