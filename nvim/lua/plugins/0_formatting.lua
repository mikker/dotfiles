return {
  {
    "stevearc/conform.nvim",
    opts = {
      lsp_fallback = true,
      formatters_by_ft = {
        ruby = { "rubocop", "rustywind" },
        css = { "prettier" },
      },
    },
  },

  -- mason.nvim
}
