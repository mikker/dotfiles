return {
  {
    "tpope/vim-rails",
    config = function()
      -- disable setting ft=eruby.yaml
      vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
        pattern = { "*.yml" },
        callback = function()
          vim.bo.filetype = "yaml"
        end,
      })
    end,
  },
  "tpope/vim-rake",
  {
    "slim-template/vim-slim",
    dependencies = { "tpope/vim-haml" },
  },
  "vim-ruby/vim-ruby",
  "zackhsi/sorbet.vim",

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "ruby",
      })
    end,
  },

  -- better matchup for ruby
  { "andymass/vim-matchup" },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function(_, opts)
      opts.matchup = { enable = true, disable = { "ruby" } }
    end,
  },
  "tpope/vim-endwise",

  -- https://github.com/Shopify/ruby-lsp/blob/main/EDITORS.md#lazyvim-lsp
  -- {
  --   "neovim/nvim-lspconfig",
  --   servers = {
  --     ruby_lsp = {
  --       mason = false,
  --       cmd = { vim.fn.expand("~/.asdf/shims/ruby-lsp") },
  --     },
  --   },
  -- },
}
