" Fmt calls 'go fmt' to convert the file to go's format standards. This being
" run often makes the undo buffer long and difficult to use. This function
" wraps the Fmt function causing it to join the format with the last action.
" This has to have a try/catch since you can't undojoin if the previous
" command was itself an undo.

let g:gofmt_command = "rubyfmt"

function! RubyFmt()
  if !exists("g:gofmt_command") || !executable(g:gofmt_command)
    return
  endif

  " Save current window
  let currwin=winnr()
  let topline = line("w0")

  " Save cursor/view info.
  windo let w:view = winsaveview()
  execute currwin . 'wincmd w'

  " Check if Fmt will succeed or not. If it will fail run again to populate
  " location window. If it succeeds then we call it with an undojoin.

  " Copy the file to a temp file and attempt to run gofmt on it
  let TempFile = tempname()
  "let SaveModified = &modified
  exe 'w ' . TempFile
  "let &modified = SaveModified
  silent exe '! ' . g:gofmt_command . ' ' . TempFile
  call delete(TempFile)

  if v:shell_error
    " Execute Fmt to populate the location window
    silent Fmt
  else
    " Clear the error list:
    call setloclist(0, [])

    " Now that we know Fmt will succeed we can now run Fmt with its undo
    " joined to the previous edit in the current buffer
    try                
      silent undojoin | silent Fmt
    catch              
    endtry
  endif
  
  " Restore the saved cursor/view info.
  windo call winrestview(w:view)
  execute currwin . 'wincmd w'

  " Toggle location window (it does the right thing!)
  lwindow
endfunction
command! RubyFmt call RubyFmt()
