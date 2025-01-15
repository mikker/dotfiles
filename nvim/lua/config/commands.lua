-- Run a terminal command in a new tab
local function runTermInTab(args)
  if vim.fn.tabpagenr() > 1 then
  -- If there is more than one tab page, do nothing
  else
    -- Open a new tab and run the terminal command
    vim.cmd("-tabnew | term " .. args)
    vim.cmd("keepalt file TT")
    vim.cmd("normal I")
  end
end

-- Create the command TT that calls the runTermInTab function
vim.api.nvim_create_user_command("TT", function(opts)
  runTermInTab(opts.args)
end, { nargs = "*", complete = "file" })

-- Open current file in "Marked 2.app"
vim.api.nvim_create_user_command("Marked", function()
  vim.system({ "open -a Marked\\ 2 " .. vim.fn.expand("%") })
end, { nargs = 0 })

vim.api.nvim_create_user_command("F", function(args)
  vim.bo.filetype = args
end, { nargs = 1 })

-- Strip trailing whitespace
function StripTrailingWhitespace()
  -- Save the current cursor position
  local current_pos = vim.api.nvim_win_get_cursor(0)
  local current_line = current_pos[1]
  local current_col = current_pos[2]

  -- Substitute command to remove trailing whitespace
  vim.cmd([[%s/\s\+$//e]])

  -- Restore the cursor position
  vim.api.nvim_win_set_cursor(0, { current_line, current_col })
end

local wk = require("which-key")
-- vim.api.nvim_set_keymap("n", "<leader>S", , { noremap = true, silent = true })
wk.add({
  { "<leader>S", ":lua StripTrailingWhitespace()<CR>", desc = "Strip whitespace", silent = true, noremap = true },
})

-- Load QuickFix list into argument list
local function QuickfixFilenames()
  local buffer_numbers = {}
  for _, quickfix_item in ipairs(vim.fn.getqflist()) do
    local qf_bufnr = quickfix_item.bufnr
    buffer_numbers[qf_bufnr] = vim.fn.bufname(quickfix_item.bufnr)
  end
  local filenames = {}
  for _, filename in pairs(buffer_numbers) do
    table.insert(filenames, vim.fn.fnameescape(filename))
  end
  return table.concat(filenames, " ")
end

vim.api.nvim_create_user_command("Qargs", function()
  vim.cmd("args " .. QuickfixFilenames())
end, { nargs = 0, bar = true })
