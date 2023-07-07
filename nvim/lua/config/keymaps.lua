local function map(mode, lhs, rhs, opts)
	local keys = require("lazy.core.handler").handlers.keys
	---@cast keys LazyKeysHandler
	-- do not create the keymap if a lazy keys handler exists
	if not keys.active[keys.parse({ lhs, mode = mode }).id] then
		opts = opts or {}
		opts.silent = opts.silent ~= false
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end
--
-- -- better up/down
-- map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- fast split movement
map("n", "<c-h>", "<c-w>h", { desc = "Go to right window" })
map("n", "<c-j>", "<c-w>j", { desc = "Go to right window" })
map("n", "<c-k>", "<c-w>k", { desc = "Go to right window" })
map("n", "<c-l>", "<c-w>l", { desc = "Go to right window" })
-- support <c-hjkl> to arrows mapped keebs
map("n", "<Left>", "<c-w>h", { desc = "Go to right window" })
map("n", "<Down>", "<c-w>j", { desc = "Go to right window" })
map("n", "<Up>", "<c-w>k", { desc = "Go to right window" })
map("n", "<Right>", "<c-w>l", { desc = "Go to right window" })

map("n", "<leader><space>", "<C-^>", { desc = "Previous buffer" })

-- tabs
map("n", "]w", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "[w", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- quicksave
map("n", "<leader>j", ":w<cr>", { desc = "Quicksave" })

-- / to search <c-/> to toggle highlight
map("n", "<c-_>", ":noh<cr>")

-- qq to record macro, Q to apply
map("n", "Q", "@q")
map("v", "Q", ":normal Q<cr>")

-- expand %% to dir of current buffer in cmd mode
map("c", "%%", "<c-r>=expand('%:h').'/'<cr>")
-- open file in same dir as current buffer
map("n", "<leader>e", ":e <c-r>=expand('%:h').'/'<cr>", { desc = "Edit in same dir" })

-- Y behaves like other capitals
map("n", "Y", "y$")

-- always jump to column, not just line
map("n", "'", "`")

-- open work dir in Finder.app
map("n", "<leader>O", ":call system('open .')<cr>", { desc = "Open cwd in Finder" })

-- close the bottom window, whatever it es
map(
	"n",
	"<leader>xc",
	":wincmd z|cclose|lclose|TroubleClose<cr>",
	{ silent = true, noremap = true, desc = "Close bottom window" }
)

-- c-c doesn't trigger InsertLeave so map to escape
map("x", "<c-c>", "<esc>")
map("i", "<c-c>", "<esc>")

-- -- commonly misspelled
-- vim.cmd([[
-- cnoreabbrev E e
-- cnoreabbrev G Git
-- cnoreabbrev Qa qa
-- ]])

-- alternative for <c-l> as my keebs have that mapped to <right>
map("i", "<c-_>", "<c-x><c-l>")

-- jump to config
map("n", "<leader>vv", ":e $MYVIMRC<cr>", { desc = "Edit vimrc" })
map("n", "<leader>vt", ":tabe $MYVIMRC<cr>", { desc = "Edit vimrc in tab" })

-- <esc> goes out of insert mode in term
map("t", "<esc>", "<c-\\><c-n>")

--  Close term buffers with <cr>
vim.cmd([[
augroup nvimrcEx
autocmd!
au TermOpen * nmap <buffer> <cr> :bd!<cr>
augroup END
]])

-- map("x", "<cr>", ":EasyAlign<cr>")

map("n", "<leader>rt", ":TestNearest<cr>", { silent = true })
map("n", "<leader>rT", ":TestFile<cr>", { silent = true })
map("n", "<leader>ra", ":TestSuite<cr>", { silent = true })
map("n", "<leader>rl", ":TestLast<cr>", { silent = true })
map("n", "<leader>rg", ":TestVisit<cr>", { silent = true })
--
-- vim.cmd("nnoremap <cr> :Rerun<cr>")
map("n", "<leader>rm", ":Rerun TestLast<cr>", { desc = "Rerun TestLast" })
map("n", "<leader>ro", ":VtrOpenRunner<cr>", { desc = "Open Tmux runner" })
map("n", "<leader>rk", ":VtrKillRunner<cr>", { desc = "Kill Tmux runner" })

map(
	"n",
	"<leader>ub",
	'<Cmd>lua vim.o.bg = vim.o.bg == "dark" and "light" or "dark"<CR>',
	{ desc = "Toggle background light/dark" }
)

--Telescope in vimwiki
map(
	"n",
	"<leader>fw",
	'<cmd>lua require("telescope.builtin").find_files({cwd = string.format("%s", vim.g.wiki_path)})<cr>',
	{ desc = "Find in Vimwiki" }
)

map("n", "\\", ":grep ")

map("n", "<cr>", ":lua require('neotest').run.run_last()<cr>", { desc = "Run last test" })
-- map("n", "<cr>", ":Rerun<cr>", { desc = "Run last test" })

map(
	"n",
	"<leader>tj",
	"<cmd>lua require('neotest').jump.next({ status = 'failed' })<cr>",
	{ desc = "Jump to next failed" }
)
map(
	"n",
	"<leader>tk",
	"<cmd>lua require('neotest').jump.prev({ status = 'failed' })<cr>",
	{ desc = "Jump to prev failed" }
)
