local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- opt.list = true -- Always show tabs and trailing spaces
-- opt.listchars = { tab = "»·", trail = "·" }

opt.autoindent = true -- indent on new line
opt.autoread = true -- try to read files on re-entry
opt.backup = false
opt.clipboard = nil
opt.completeopt = "menu,menuone,noselect" -- mostly just for cmp
opt.cursorline = true
opt.directory = "~/.tmp,/tmp"
opt.expandtab = true -- spaces for indentation
opt.exrc = true -- auto-source local .nvimrc
opt.gdefault = true -- /g by default
opt.hidden = true
opt.history = 10000
opt.ignorecase = true -- Search is case-insensitive
opt.inccommand = "nosplit" -- live preview :s commands
opt.laststatus = 0 -- Always show status bar"
opt.mouse = "a"
opt.number = true
opt.relativenumber = false
opt.secure = true -- ... but restrict it to be safe
opt.shiftwidth = 2
opt.shortmess:append({ W = true, I = true, c = true })
opt.signcolumn = "auto"
opt.smartcase = true -- ...unless uppercase
opt.smartindent = true
opt.softtabstop = 2
opt.swapfile = false
opt.tabstop = 2
opt.tags = ".git/tags"
opt.termguicolors = true
opt.timeoutlen = 300
opt.undodir = "~/.tmp,/tmp"
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- faster completion
opt.wildignorecase = true -- Ignore case in command mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.wrap = true
opt.writebackup = false

if vim.fn.executable("rg") then
	opt.grepprg = "rg --vimgrep"
end

if vim.fn.has("nvim-0.9.0") == 1 then
	opt.splitkeep = "screen"
	opt.shortmess:append({ C = true })
end

vim.g.markdown_recommended_style = 0

-- Automatic dark mode on boot
if vim.fn.executable("is-this-dark-mode") then
	vim.fn.system("is-this-dark-mode")

	if vim.v.shell_error == 0 then
		vim.opt.background = "dark"
	else
		vim.opt.background = "light"
	end
end

local is_ui = vim.fn.has("gui_vimr") == 1 or vim.g.neovide

vim.opt.guifont = { "Iosevka Light", ":h18" }

if is_ui then
	--  act as in a term
	vim.api.nvim_set_keymap("n", "<c-z>", ":term<cr>", {})

	vim.cmd([[cd ~/Library/Mobile Documents/27N4MQEA55~pro~writer/Documents]])

	vim.cmd([[
  autocmd VimEnter * if argc() == 0 | normal <leader>ww | endif
  ]])
end

vim.cmd([[
let g:neovide_cursor_animation_length=0.0001
let g:neovide_cursor_trail_length=0.0001
let g:neovide_refresh_rate=140
]])

if vim.g.neovide then
	vim.g.neovide_input_use_logo = 1 -- enable use of the logo (cmd) key
end
