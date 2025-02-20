-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function map(mode, lhs, rhs, opts)
  -- opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

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

-- qq to record macro, Q to apply
map("n", "Q", "@q")
map("v", "Q", ":normal Q<cr>")

-- expand %% to dir of current buffer in cmd mode
map("c", "%%", "<c-r>=expand('%:h').'/'<cr>")
-- open file in same dir as current buffer
map("n", "<leader>e", ":e <c-r>=expand('%:h').'/'<cr>", { desc = "Edit in same dir" })

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

map(
  "n",
  "<leader>ub",
  '<Cmd>lua vim.o.bg = vim.o.bg == "dark" and "light" or "dark"<CR>',
  { desc = "Toggle background light/dark" }
)

map("n", "\\", ":grep! ")

vim.keymap.set("n", "<leader>oc", function()
  local file = vim.fn.shellescape(vim.fn.expand("%:p"))
  local line = vim.fn.line(".")
  vim.cmd(string.format("silent !cursor . -g %s:%s", file, line))
end, { desc = "Open file in Cursor" })
