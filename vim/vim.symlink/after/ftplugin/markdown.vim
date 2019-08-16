xnoremap <buffer> <leader>b c**<C-r>"**<Esc>
xnoremap <buffer> <leader>i c_<C-r>"_<Esc>
xnoremap <buffer> <leader>c c`<C-r>"`<Esc>
xmap <buffer> <leader>lc S]f]a(<c-r>*)<esc>
xmap <buffer> <leader>ll S]f]a[]<esc>i
nmap <leader>i i![](<c-r>*)<c-o>F]

nnoremap <buffer> <leader>r :Marked<cr>
nnoremap <buffer> <leader>I i![](<c-r>*)<esc>

nnoremap <buffer> <leader>q I><space><esc>

nnoremap <buffer> <leader>1 yypv$r=
nnoremap <buffer> <leader>2 I## <esc>

" nnoremap <buffer> - <Plug>VinegarUp

set fdm=indent
