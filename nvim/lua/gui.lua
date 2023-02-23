-- when in VimR.app
local is_ui = vim.fn.has("gui_vimr") == 1 or vim.g.neovide

vim.opt.guifont = { "Iosevka Light", ":h18" }

if is_ui then
  --  act as in a term
  vim.api.nvim_set_keymap('n', '<c-z>', ':term<cr>', {})

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
  vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  vim.keymap.set('v', '<D-c>', '"+y') -- Copy
  vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
  vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode

  -- Allow clipboard copy paste in neovim
  vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true})
  vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true})
  vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true})
  vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true})
end

