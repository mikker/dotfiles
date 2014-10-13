xnoremap <buffer> +b c**<C-r>"**<Esc>
xnoremap <buffer> +i c_<C-r>"_<Esc>
xnoremap <buffer> +c c`<C-r>"`<Esc>
nnoremap <buffer> <leader>q I><space><esc>

" Open current file in Marked
fun! Marked()
  call system("open -a Marked\ 2 " . expand("%"))
endfun
com! Marked call Marked()

nnoremap <buffer> <leader>r :Marked<cr>

xmap <leader>lc S]f]a(<c-r>*)<esc>
