return {
  -- list
  {
    "bjarneo/pixel.nvim",
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme("pixel")
    end,
  },
  {
    "mcchrish/zenbones.nvim",
    dependencies = "rktjmp/lush.nvim",
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
  },

  -- set
  { "LazyVim/LazyVim", opts = { colorscheme = "zenbones" } },
}
