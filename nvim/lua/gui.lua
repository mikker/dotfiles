-- when in VimR.app
if vim.fn.has("gui_vimr") == 1 then
  --  act as in a term
  vim.api.nvim_set_keymap('n', '<c-z>', ':term<cr>', {})

  vim.opt.background = 'light'

  vim.cmd([[cd ~/Documents/Wiki]])
  vim.g.goyo_height = '100%'

  vim.cmd([[
  autocmd VimEnter * if argc() == 0 | execute 'VimwikiIndex' | execute 'Goyo' | endif
  ]])
end

vim.cmd([[
set guifont=Iosevka\ Nerd\ Font:h18
let g:neovide_cursor_animation_length=0.0001
let g:neovide_cursor_trail_length=0.0001
let g:neovide_refresh_rate=140
]])
