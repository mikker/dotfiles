setlocal foldmethod=indent
setlocal iskeyword+=@

command! -nargs=0 Rubyfmt %!rubyfmt %
nnoremap <leader>R :Rubyfmt<cr>

" source /Users/mikker/dev/vendor/rubyfmt/rubyfmt.vim
" let g:rubyfmt_path = '/Users/mikker/dev/vendor/rubyfmt/rubyfmt.rb'

