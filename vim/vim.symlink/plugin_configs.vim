xmap <cr> :EasyAlign<cr>

let g:vimwiki_ext2syntax = {}
let g:vimwiki_list = [{'path': '~/Documents/Wiki/', 'syntax': 'markdown', 'ext': '.md'}]

com! -bang Wiki call fzf#vim#files('~/Documents/Wiki/', fzf#vim#with_preview(), <bang>0)
nnoremap <leader>W :Wiki<cr>

" Use :TT for vim-test
fun! TTStrategy(cmd)
  execute 'TT ' . a:cmd
endfun

let g:test#custom_strategies = { "tt": function('TTStrategy') }

if has('nvim')
  let test#strategy = "tt"
else
  let test#strategy = "basic"
endif

let test#strategy = "vtr"

nmap <silent> <leader>tt :TestNearest<CR>
nmap <silent> <leader>tT :TestFile<CR>
nmap <silent> <leader>ta :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tg :TestVisit<CR>

" https://github.com/mikker/vim-rerunner
let g:rerunner_focus = 'TestLast'
map <leader>md :Rerun TestLast<cr>

augroup pencil
  autocmd!
  autocmd FileType markdown,mkd,text call pencil#init()
augroup END

let g:pencil#wrapModeDefault = 'soft'
let g:pencil#conceallevel = 0
let g:pencil#concealcursor = 'c'

map <leader>G :Goyo<cr>

call togglebg#map("<f5>")

let g:VtrOrientation = 'h'
let g:VtrPercentage = 40
let g:VtrClearBeforeSend = 0

map <leader>ro :VtrOpenRunner<cr>
map <leader>rk :VtrKillRunner<cr>

iabbrev donatoin donation

set tags^=./.git/tags

