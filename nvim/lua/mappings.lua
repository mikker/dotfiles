vim.g.mapleader = " "

local function map(a, b, c, d) vim.keymap.set(a, b, c, d) end
local function nrmap(a, b, c, d)
  d = d == nil and {} or d
  vim.keymap.set(a, b, c, table.insert(d, {noremap = true}))
end

-- double leader flips between previous and current buffer
nrmap("n", "<leader><leader>", "<c-^>")

-- quicksave
map("n", "<leader>j", ":w<cr>")

-- / to search <c-/> to toggle highlight
nrmap("n", "<c-_>", ":set hlsearch!<cr>")

-- old leader is new grep
nrmap("n", "\\", ":Ack")

-- qq to record macro, Q to apply
map("n", "Q", "@q")
map("v", "Q", ":normal Q<cr>")

-- expand %% to dir of current buffer in cmd mode
map("c", "%%", "<c-r>=expand('%:h').'/'<cr>")
-- open file in same dir as current buffer
map("n", "<leader>e", ":e %%")

-- visual line movement
nrmap("n", "k", "gk")
nrmap("n", "j", "gj")
nrmap("n", "gk", "k")
nrmap("n", "gj", "j")

-- fast split movement
nrmap("n", "<c-h>", "<c-w>h")
nrmap("n", "<c-j>", "<c-w>j")
nrmap("n", "<c-k>", "<c-w>k")
nrmap("n", "<c-l>", "<c-w>l")
-- support <c-hjkl> to arrows mapped keebs
nrmap("n", "<Left>", "<c-w>h")
nrmap("n", "<Down>", "<c-w>j")
nrmap("n", "<Up>", "<c-w>k")
nrmap("n", "<Right>", "<c-w>l")

-- tabs
nrmap("n", "]w", ":tabn<cr>")
nrmap("n", "[w", ":tabp<cr>")

-- Y behaves like other capitals
nrmap("n", "Y", "y$")

-- always jump to column, not just line
nrmap("n", "'", "`")

-- visual indenting keeps selection
nrmap("v", "<", "<gv")
nrmap("v", ">", ">gv")

-- open work dir in Finder.app
nrmap("n", "<leader>O", ":call system('open .')<cr>")

-- close the bottom window, whatever it es
nrmap("n", "<silent> <c-w>z", ":wincmd z|cclose|lclose")

-- c-c doesn't trigger InsertLeave so map to escape
nrmap("x", "<c-c>", "<esc>")
nrmap("i", "<c-c>", "<esc>")

-- expand date and time
vim.cmd([[
iab <expr> ddate strftime("%Y-%m-%d")
iab <expr> ttime strftime("%H:%M")
]])

-- commonly misspelled
vim.cmd([[
cnoreabbrev E e
cnoreabbrev G Git
cnoreabbrev Qa qa
]])

-- alternative for <c-l> as my keebs have that mapped to <right>
nrmap("i", "<c-_>", "<c-x><c-l>")

-- jump to config
nrmap("n", "<leader>vv", ":e $MYVIMRC<cr>")

-- <esc> goes out of insert mode in term
nrmap("t", "<esc>", "<c-\\><c-n>")

--  Close term buffers with <cr>
vim.cmd([[
augroup nvimrcEx
autocmd!
au TermOpen * nmap <buffer> <cr> :bd!<cr>
augroup END
]])

-- Fuzzy find
nrmap('n', '<leader>f', '<cmd>Telescope find_files<cr>')
nrmap('n', '<leader>b', '<cmd>Telescope buffers<cr>')
