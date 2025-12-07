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

  -- {
  --   "razak17/tailwind-fold.nvim",
  --   opts = {
  --     enabled = false,
  --     symbol = "󱏿",
  --   },
  --   keys = {
  --     { "<leader>ut", "<cmd>TailwindFoldToggle<cr>", desc = "Toggle Tailwind Fold" },
  --   },
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   ft = { "html", "svelte", "astro", "vue", "typescriptreact", "php", "blade", "slim", "eruby" },
  -- },

  {
    "nvim-mini/mini.splitjoin",
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

  -- "nvim-mini/mini.bracketed",
  "mbbill/undotree",
  "whiteinge/diffconflicts",

  {
    "stevearc/oil.nvim",
    opts = {
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["<C-r>"] = "actions.refresh",
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
      },
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

}
