return {
  -- moar
  "tpope/vim-abolish", -- :S smart replace
  "tpope/vim-eunuch", -- unix things
  "tpope/vim-fugitive", -- git things
  "tpope/vim-rhubarb", -- github things
  "tpope/vim-projectionist", -- project navigation

  {
    "folke/which-key.nvim",
    opts = function()
      local wk = require("which-key")
      wk.add({
        { "<leader>m", group = "+rerun" },
        { "<leader>t", group = "+vimtest" },
        { "<leader>v", group = "+nvimrc" },
      })
    end,
  },

  {
    "mikker/vim-rerunner",
    dev = true,
    cmd = { "Rerun", "RerunWhat" },
    keys = {
      { "<cr>", "<cmd>Rerun<cr>", desc = "Run", mode = "n" },
    },
    config = function()
      vim.g.rerunner_focus = "TestLast"
    end,
  },

  {
    "mattn/emmet-vim",
    init = function()
      vim.g.user_emmet_leader_key = "<c-.>"
    end,
  },
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
