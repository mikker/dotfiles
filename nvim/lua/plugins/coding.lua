return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- see the "default configuration" section below for full documentation on how to define
      -- your own keymap.
      opts.keymap = {
        preset = "super-tab",
      }
    end,
  },

  -- { "rafamadriz/friendly-snippets", enabled = false },
  { "echasnovski/mini.pairs", enabled = false },

  -- extras
  -- {
  --   "zbirenbaum/copilot.lua",
  --   opts = function(_, opts)
  --     opts.suggestion = { enabled = true }
  --     opts.filetypes = {
  --       markdown = false,
  --     }
  --   end,
  -- },

  -- additions
  "tpope/vim-abolish", -- :S smart replace
  "tpope/vim-eunuch", -- unix things
  "tpope/vim-fugitive", -- git things
  "tpope/vim-rhubarb", -- github things
  "tpope/vim-projectionist", -- project navigation

  -- {
  --   "christoomey/vim-tmux-runner",
  --   init = function()
  --     vim.g.VtrOrientation = "h"
  --     vim.g.VtrPercentage = 40
  --     vim.g.VtrClearBeforeSend = false
  --   end,
  --   keys = {
  --     { "<leader>ro", ":VtrOpenRunner<cr>", desc = "Open Tmux runner" },
  --     { "<leader>rk", ":VtrKillRunner<cr>", desc = "Kill Tmux runner" },
  --   },
  -- },
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
}
