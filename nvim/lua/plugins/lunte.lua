return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local lspconfig = require("lspconfig")
      local configs = require("lspconfig.configs")

      if not configs.lunte then
        configs.lunte = {
          default_config = {
            cmd = { "npx", "-y", "lunte-lsp" },
            filetypes = { "javascript" },
            root_dir = lspconfig.util.root_pattern("package.json", ".git"),
            single_file_support = true,
          },
        }
      end

      opts.servers.lunte = {}
    end,
  },
}
