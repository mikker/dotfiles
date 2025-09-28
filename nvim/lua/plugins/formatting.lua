return {
  {
    "stevearc/conform.nvim",
    opts = {
      -- Use LSP formatting for ERB via herb_ls (Conform lsp_fallback)
      lsp_fallback = true,
      formatters_by_ft = {
        solidity = { "forge" },
        -- Use LSP for ERB (herb_ls); no external CLI formatter here
        eruby = {},
        slim = { "rustywind" },
        ruby = { "rubocop", "rustywind" },
        yaml = {},
        -- Disable erb_format for YAML files
        ["eruby.yaml"] = { "rustywind" },
      },
      formatters = {
        forge = {
          command = "forge",
          args = { "fmt", "-r", "-" },
          stdin = true,
        },
      },
    },
  },
}
