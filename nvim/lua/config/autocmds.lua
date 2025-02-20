-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  group = augroup("term"),
  command = "nmap <buffer> <cr> :bd!<cr>",
})

local magic_markers = augroup("magic_markers")
vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "*.{erb,html,haml,slim,eex}",
  group = magic_markers,
  command = 'exe "normal! mH"',
})
vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "*.css",
  group = magic_markers,
  command = 'exe "normal! mS"',
})
vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "*.{js,jsx,ts,tsx}",
  group = magic_markers,
  command = 'exe "normal! mJ"',
})
vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "*.{rb,ex,exs}",
  group = magic_markers,
  command = 'exe "normal! mC"',
})
vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "*.yml",
  group = magic_markers,
  command = 'exe "normal! mY"',
})

local grepQuickFix = augroup("grep_quickfix")
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "*",
  group = grepQuickFix,
  command = "cwindow | redraw",
})
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  group = grepQuickFix,
  command = "if &buftype == 'quickfix' | nnoremap <buffer> <cr> <cr> | endif",
})
