local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- extras
    -- { import = "lazyvim.plugins.extras.coding.copilot" },
    -- { import = "lazyvim.plugins.extras.coding.copilot-chat" },
    -- { import = "lazyvim.plugins.extras.coding.mini-surround" },
    -- { import = "lazyvim.plugins.extras.editor.telescope" },
    --   { import = "lazyvim.plugins.extras.editor.mini-move" },
    --   { import = "lazyvim.plugins.extras.editor.dial" },
    --   { import = "lazyvim.plugins.extras.formatting.prettier" },
    --   { import = "lazyvim.plugins.extras.lang.tailwind" },
    --   { import = "lazyvim.plugins.extras.lang.typescript" },
    --   { import = "lazyvim.plugins.extras.linting.eslint" },
    --   { import = "lazyvim.plugins.extras.util.mini-hipatterns" },
    --  plugins
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = {
    colorscheme = { "zenbones" },
    checker = { enabled = true },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        --         -- "matchit",
        --         -- "matchparen",
        --         -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  dev = {
    path = "~/dev",
    patterns = { "mikker" },
    fallback = true,
  },
})

-- require("config/commands")
