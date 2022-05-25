local function map(a, b, c, d) vim.keymap.set(a, b, c, d) end
local function nrmap(a, b, c, d)
  d = d == nil and {} or d
  vim.keymap.set(a, b, c, table.insert(d, {remap = false}))
end

map("x", "<cr>", ":EasyAlign<cr>")

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

map("n", "<silent> <leader>tt", ":TestNearest<cr>")
map("n", "<silent> <leader>tT", ":TestFile<cr>")
map("n", "<silent> <leader>ta", ":TestSuite<cr>")
map("n", "<silent> <leader>tl", ":TestLast<cr>")
map("n", "<silent> <leader>tg", ":TestVisit<cr>")

-- https://github.com/mikker/vim-rerunner
vim.g.rerunner_focus = "TestLast"
map("n", "<leader>md", ":Rerun TestLast<cr>")

vim.cmd([[
augroup pencil
  autocmd!
  autocmd FileType markdown,mkd,text call pencil#init()
augroup END
]])

vim.g['pencil#wrapModeDefault'] = 'soft'
vim.g['pencil#conceallevel'] = 0
vim.g['pencil#concealcursor'] = 'c'

map("n", "<leader>G", ":Goyo<cr>")

vim.call("togglebg#map", "<f5>")

vim.g.VtrOrientation = "h"
vim.g.VtrPercentage = 40
vim.g.VtrClearBeforeSend = false

map("n", "<leader>ro", ":VtrOpenRunner<cr>")
map("n", "<leader>rk", ":VtrKillRunner<cr>")

require('lualine').setup {
  options = {
    icons_enabled = true,
    section_separators = '',
    component_separators = '',
  },

  sections = {
    lualine_a = {'mode', 'paste'},
    lualine_b = {'branch', 'diff'},
    lualine_c = {'readonly', {'filename', path = 1}},

    lualine_x = {'filetype'},
    lualine_y = {'diagnostics'},
    lualine_z = {}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},

    lualine_x = {'filetype'},
    lualine_y = {},
    lualine_z = {}
  }
}

vim.g.FerretMap = 0

require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  ignore_install = { "phpdoc" },
}

