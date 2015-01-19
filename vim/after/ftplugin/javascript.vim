setlocal foldmethod=syntax
setlocal foldlevel=999
setlocal iskeyword+=$

setlocal tabstop=4 shiftwidth=4

map <buffer> <leader>B i_.bind(<esc>f{%a, this)<esc>
noremap <buffer> <leader>j iinject(<esc>f(ma$%a)<esc>`aa


