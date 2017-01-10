xnoremap <buffer> <leader>b c**<C-r>"**<Esc>
xnoremap <buffer> <leader>i c_<C-r>"_<Esc>
xnoremap <buffer> <leader>c c`<C-r>"`<Esc>
xmap <buffer> <leader>lc S]f]a(<c-r>*)<esc>

nnoremap <buffer> <leader>q I><space><esc>
nnoremap <buffer> <leader>r :Marked<cr>
nnoremap <buffer> <leader>I i![](<c-r>*)<esc>

nmap <buffer> <tab> :s/\v^(#{0,})\s?(\w)?/\1# \2/<cr>
nmap <buffer> <s-tab> :s/\v^#(\s([^\s]))?/\2/<cr>

nmap <buffer> <leader>1 yypv$r=
nmap <buffer> <leader>2 I##<esc>
