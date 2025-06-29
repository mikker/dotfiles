return {
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },

  { "folke/flash.nvim", enabled = false },
  { "lewis6991/gitsigns.nvim", enabled = false },

  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<leader><space>", false },
    },
  },

  -- extras
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
    "echasnovski/mini.splitjoin",
    init = function()
      require("mini.splitjoin").setup({})
    end,
  },

  {
    "junegunn/vim-easy-align",
    keys = {
      { "<leader>A", "<cmd>EasyAlign<cr>", mode = "x", desc = "Align selection" },
    },
  },

  -- "echasnovski/mini.bracketed",
  "mbbill/undotree",
  "whiteinge/diffconflicts",

  {
    "stevearc/oil.nvim",
    opts = {
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
        sort = {
          { "name", "asc" },
          { "type", "asc" },
        },
      },
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<CMD>Oil<cr>" },
    },
  },

  "jonsmithers/vim-html-template-literals",
}
