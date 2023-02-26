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
vim.api.nvim_set_keymap("n", "<leader>md", ":Rerun TestLast<cr>", { desc = "Rerun TestLast" })

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

-- vim.g.VtrOrientation = "h"
-- vim.g.VtrPercentage = 40
-- vim.g.VtrClearBeforeSend = false

-- map("n", "<leader>ro", ":VtrOpenRunner<cr>")
-- map("n", "<leader>rk", ":VtrKillRunner<cr>")

-- require('lualine').setup {
--   options = {
--     icons_enabled = true,
--     section_separators = '',
--     component_separators = '',
--   },

--   sections = {
--     lualine_a = {'mode', 'paste'},
--     lualine_b = {'branch', 'diff'},
--     lualine_c = {'readonly', {'filename', path = 1}},

--     lualine_x = {'filetype'},
--     lualine_y = {'diagnostics'},
--     lualine_z = {}
--   },
--   inactive_sections = {
--     lualine_a = {},
--     lualine_b = {},
--     lualine_c = {'filename'},

--     lualine_x = {'filetype'},
--     lualine_y = {},
--     lualine_z = {}
--   }
-- }

-- vim.g.FerretMap = 0

-- require'nvim-treesitter.configs'.setup {
--   ensure_installed = "all",
--   ignore_install = { "phpdoc" },
-- }

-- vim.cmd([[
-- let g:vimwiki_list = [{ 'path': '~/Library/Mobile Documents/27N4MQEA55~pro~writer/Documents/', 'syntax': 'markdown', 'ext': '.md' }]
-- let g:vimwiki_global_ext = 0
-- ]])

-- require 'colorizer'.setup {
--   tailwind = true
-- }
