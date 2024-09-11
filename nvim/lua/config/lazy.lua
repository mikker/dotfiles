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
    { import = "plugins" },
    {
      "razak17/tailwind-fold.nvim",
      opts = {
        enabled = false,
        symbol = "󱏿",
      },
      keys = {
        { "<leader>ut", "<cmd>TailwindFoldToggle<cr>", desc = "Toggle Tailwind Fold" },
      },
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      ft = { "html", "svelte", "astro", "vue", "typescriptreact", "php", "blade", "slim", "eruby" },
    },
    {
      "yetone/avante.nvim",
      event = "VeryLazy",
      build = "make",
      opts = {
        hints = { enabled = false },
      },
      dependencies = {
        "nvim-tree/nvim-web-devicons",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below is optional, make sure to setup it properly if you have lazy=true
        {
          "MeanderingProgrammer/render-markdown.nvim",
          opts = {
            file_types = { "markdown", "Avante" },
          },
          ft = { "markdown", "Avante" },
        },
      },
    },
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
