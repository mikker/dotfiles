local Util = require("lazyvim.util")

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

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

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

map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

map("n", "gw", "*N")
map("x", "gw", "*N")

-- -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
-- map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
-- map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
-- map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
-- map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
-- map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
-- map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- lazy
map("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- stylua: ignore start

-- toggle options
map("n", "<leader>uf", require("lazyvim.plugins.lsp.format").toggle, { desc = "Toggle format on Save" })
map("n", "<leader>us", function() Util.toggle("spell") end, { desc = "Toggle Spelling" })
map("n", "<leader>uw", function() Util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
map("n", "<leader>ul", function() Util.toggle("relativenumber", true) Util.toggle("number") end, { desc = "Toggle Line Numbers" })
map("n", "<leader>ud", Util.toggle_diagnostics, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>uc", function() Util.toggle("conceallevel", false, {0, conceallevel}) end, { desc = "Toggle Conceal" })

-- lazygit
map("n", "<leader>gg", function() Util.float_term({ "lazygit" }, { cwd = Util.get_root() }) end, { desc = "Lazygit (root dir)" })
map("n", "<leader>gG", function() Util.float_term({ "lazygit" }) end, { desc = "Lazygit (cwd)" })

-- highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
  map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
end

-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
map("n", "<leader>w-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right" })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right" })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- quicksave
map("n", "<leader>j", ":w<cr>", { desc = "Quicksave" })

-- / to search <c-/> to toggle highlight
map("n", "<c-_>", ":set hlsearch!<cr>")

-- qq to record macro, Q to apply
map("n", "Q", "@q")
map("v", "Q", ":normal Q<cr>")

-- expand %% to dir of current buffer in cmd mode
map("c", "%%", "<c-r>=expand('%:h').'/'<cr>")
-- open file in same dir as current buffer
map("n", "<leader>e", ":e <c-r>=expand('%:h').'/'<cr>")

-- Y behaves like other capitals
map("n", "Y", "y$")

-- always jump to column, not just line
map("n", "'", "`")

-- visual indenting keeps selection
map("v", "<", "<gv")
map("v", ">", ">gv")

-- open work dir in Finder.app
map("n", "<leader>O", ":call system('open .')<cr>", { desc = "Open cwd in Finder" })

-- close the bottom window, whatever it es
map("n", "<leader>xc", ":wincmd z|cclose|lclose|TroubleClose<cr>", { silent = true, noremap = true, desc = "Close bottom window" })

-- c-c doesn't trigger InsertLeave so map to escape
map("x", "<c-c>", "<esc>")
map("i", "<c-c>", "<esc>")

-- commonly misspelled
vim.cmd([[
cnoreabbrev E e
cnoreabbrev G Git
cnoreabbrev Qa qa
]])

-- alternative for <c-l> as my keebs have that mapped to <right>
map("i", "<c-_>", "<c-x><c-l>")

-- jump to config
map("n", "<leader>vv", ":e $MYVIMRC<cr>", { desc = "Edit vimrc" })

-- <esc> goes out of insert mode in term
map("t", "<esc>", "<c-\\><c-n>")

--  Close term buffers with <cr>
vim.cmd([[
augroup nvimrcEx
autocmd!
au TermOpen * nmap <buffer> <cr> :bd!<cr>
augroup END
]])

map("x", "<cr>", ":EasyAlign<cr>")

map("n", "<leader>tt", ":TestNearest<cr>", {silent = true})
map("n", "<leader>tT", ":TestFile<cr>", {silent = true})
map("n", "<leader>ta", ":TestSuite<cr>", {silent = true})
map("n", "<leader>tl", ":TestLast<cr>", {silent = true})
map("n", "<leader>tg", ":TestVisit<cr>", {silent = true})
