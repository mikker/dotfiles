let g:mapleader="\<Space>"

" jumping
nnoremap <leader><leader> <c-^>
" so fast save save save
nmap <leader>j :w<cr>
" / to search, <c-/> to clear search
" term:
noremap <c-_> :set hlsearch!<cr>
" gui:
noremap <c-/> :set hlsearch!<cr>
" old leader is the new project wide search
nnoremap \ :Ack<SPACE>

" qq to record, Q to replay
nmap Q @q
vmap Q :normal Q<cr>

" %% expands to dir of current file in cmd mode
cmap %% <C-R>=expand('%:h').'/'<cr>
" edit file in the same directory as the current file
nmap <leader>e :edit %%

" visual moving
noremap k gk
noremap j gj
noremap gk k
noremap gj j

" Easy split navigation
nnoremap <C-h>  <C-w>h
nnoremap <C-j>  <C-w>j
nnoremap <C-k>  <C-w>k
nnoremap <C-l>  <C-w>l
nnoremap <Left>  <C-w>h
nnoremap <Down>  <C-w>j
nnoremap <Up>  <C-w>k
nnoremap <Right>  <C-w>l

" tabs
nnoremap ]w :tabn<cr>
nnoremap [w :tabp<cr>

" Y behaves like other capital letters
nnoremap Y y$

" always jump to mark column (and not just line)
noremap ' `

" Indenting visual selection keeps selection
vnoremap < <gv
vnoremap > >gv

" Open pwd in Finder.app
nnoremap <leader>O :call system('open .')<cr>

" Just, you know, close the bottom window
nnoremap <silent> <c-w>z :wincmd z<bar>cclose<bar>lclose<cr>

" c-c doesn't trigger InsertLeave by default so we map it to regular esc
xnoremap <c-c> <esc>
inoremap <c-c> <esc>

" set <cr> to reload browsers
" for the scripts, see https://github.com/mikker/dotfiles/tree/master/bin
noremap <leader>mc :Rerun call system('reload-chrome')<cr>
noremap <leader>ms :Rerun call system('reload-safari')<cr>
noremap <leader>mr :Rerun call system('reload-firefox-dev')<cr>

" wait what time is it?
iab <expr> ddate strftime("%Y-%m-%d")
iab <expr> ttime strftime("%H:%M")

" stupid hands
cnoreabbrev E e
cnoreabbrev G Git
cnoreabbrev Qa qa

inoremap <c-_> <c-x><c-l>



let g:endwise_no_mappings = 1
ino <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"

