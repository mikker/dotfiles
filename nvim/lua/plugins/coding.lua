return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap["<Tab>"] = {
        require("blink.cmp.keymap.presets").get("super-tab")["<Tab>"][1],
        LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
        "fallback",
      }
    end,
  },

  { "rafamadriz/friendly-snippets", enabled = false },
  { "echasnovski/mini.pairs", enabled = false },

  "tpope/vim-abolish", -- :S smart replace
  "tpope/vim-eunuch", -- unix things
  "tpope/vim-fugitive", -- git things
  "tpope/vim-rhubarb", -- github things
  "tpope/vim-projectionist", -- project navigation

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
      vim.g.user_emmet_leader_key = "<c-x>"
    end,
  },
}
