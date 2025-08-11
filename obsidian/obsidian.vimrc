nmap j gj
nmap k gk

set clipboard=unnamed

exmap surround_double_quotes surround " "
exmap surround_single_quotes surround ' '
exmap surround_backticks surround ` `
exmap surround_brackets surround ( )
exmap surround_square_brackets surround [ ]
exmap surround_curly_brackets surround { }
map gsa" :surround_double_quotes<CR>
map gsa' :surround_single_quotes<CR>
map gsa` :surround_backticks<CR>
map gsa( :surround_brackets<CR>
map gsa) :surround_brackets<CR>
map gsa[ :surround_square_brackets<CR>
map gsa] :surround_square_brackets<CR>
map gsa{ :surround_curly_brackets<CR>
map gsa} :surround_curly_brackets<CR>
map gsa[ :surround_square_brackets<CR>
map gsa] :surround_square_brackets<CR>

exmap togglefold obcommand editor:toggle-fold
nmap za :togglefold<CR>

unmap <Space>
nmap <Space>j :w<cr>
