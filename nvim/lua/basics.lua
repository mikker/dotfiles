local o = vim.opt

-- Keep history and backups out of working dirs
o.backup = false
o.writebackup = false
o.swapfile = false
o.directory = "~/.tmp,/tmp"
o.history = 10000

-- Persistent undo between sessions
o.undofile = true
o.undodir = "~/.tmp,/tmp"
o.undolevels = 1000

o.mouse = "nvi"
o.cursorline = true
o.hidden = true
o.number = true

-- Always show tabs and trailing spaces
o.listchars = "tab:»·,trail:·"
o.list = true

-- Search and status
o.laststatus = 2 -- Always show status bar"
o.wildignorecase = true -- Ignore case in command mode
o.ignorecase = true -- Search is case-insensitive
o.smartcase = true -- ...unless uppercase
o.gdefault = true -- /g by default
o.inccommand = 'nosplit' -- live preview :s commands

o.updatetime = 100 -- faster completion
o.completeopt = { "menuone", "noselect" } -- mostly just for cmp

o.autoindent = true -- indent on new line
o.expandtab = true -- spaces for indentation
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2

o.autoread = true -- try to read files on re-entry

o.exrc = false -- auto-source local .nvimrc / DEPRECATED, trying plugins
o.secure = true -- ... but restrict it to be safe

if vim.fn.executable("rg") then
  o.grepprg = "rg --vimgrep"
end

o.tags = ".git/tags"

-- looks
o.termguicolors = true
o.background = 'dark'
