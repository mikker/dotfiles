-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.backup = false
opt.clipboard = "" -- don't sync with OS
opt.exrc = true -- auto-source local .nvimrc
opt.history = 10000

opt.relativenumber = false
opt.signcolumn = "auto"
opt.statuscolumn = ""
opt.spell = false

opt.swapfile = false
opt.undodir = "~/.tmp,/tmp"

opt.wrap = true
opt.gdefault = true

opt.listchars:append({ trail = "·", nbsp = "·" })

-- Automatic dark mode on boot
if vim.fn.executable("is-this-dark-mode") then
  vim.fn.system("is-this-dark-mode")
  if vim.v.shell_error == 0 then
    vim.opt.background = "dark"
  else
    vim.opt.background = "light"
  end
end

if not vim.fn.has("gui_vimr") then
  -- vim.opt.guifont = { "Iosevka Light", ":h20" }
  vim.opt.guifont = "Iosevka:h20"
end

local is_ui = vim.fn.has("gui_vimr") == 1 or vim.g.neovide

if is_ui then
  vim.api.nvim_set_keymap("n", "<c-z>", ":term<cr>", {})
end

vim.cmd([[
  let g:neovide_cursor_animation_length=0.0001
  let g:neovide_cursor_trail_length=0.0001
  let g:neovide_refresh_rate=140
]])

if vim.g.neovide then
  vim.g.neovide_input_use_logo = 1 -- enable use of the logo (cmd) key
end

-- lazyvim
vim.g.snacks_animate = false
vim.g.trouble_lualine = false
vim.g.lazyvim_prettier_needs_config = false -- always enable prettier
vim.g.lazyvim_ruby_formatter = "rubyfmt"
