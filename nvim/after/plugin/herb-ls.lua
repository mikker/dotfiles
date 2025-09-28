-- Ensure custom herb_ls server exists and is set up, even if lspconfig lacks it
local ok_lsp, lspconfig = pcall(require, "lspconfig")
if not ok_lsp then
  return
end

local util = require("lspconfig.util")
local configs = require("lspconfig.configs")

if not configs.herb_ls then
  configs.herb_ls = {
    default_config = {
      cmd = { "herb-language-server", "--stdio" },
      filetypes = { "html", "eruby" },
      root_dir = function(fname)
        return (util.root_pattern("Gemfile", ".git")(fname)) or vim.loop.cwd()
      end,
    },
  }
end

-- Call setup to register with lspconfig (no-op if already set by other config)
if lspconfig.herb_ls and not lspconfig.herb_ls._custom_setup_applied then
  lspconfig.herb_ls.setup({})
  lspconfig.herb_ls._custom_setup_applied = true
end

