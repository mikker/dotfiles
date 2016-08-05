setlocal foldmethod=indent
setlocal iskeyword+=@

augroup rubyFT
  autocmd!
  au BufWritePost *.rb Neomake
augroup END
