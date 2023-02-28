vim.cmd([[
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
]])

-- https://github.com/mikker/vim-rerunner
vim.g.rerunner_focus = "TestLast"

-- vim.cmd([[
-- augroup pencil
--   autocmd!
--   autocmd FileType markdown,mkd,text call pencil#init()
-- augroup END
-- ]])

-- vim.g['pencil#wrapModeDefault'] = 'soft'
-- vim.g['pencil#conceallevel'] = 0
-- vim.g['pencil#concealcursor'] = 'c'

-- map("n", "<leader>G", ":Goyo<cr>")

vim.cmd("call togglebg#map('<f5>')")

vim.g.VtrOrientation = "h"
vim.g.VtrPercentage = 40
vim.g.VtrClearBeforeSend = false
