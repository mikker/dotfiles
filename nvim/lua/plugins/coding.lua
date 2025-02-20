return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = { preset = "super-tab" },
      sources = {
        default = { "snippets", "lsp", "path", "buffer" },
      },
    },
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
