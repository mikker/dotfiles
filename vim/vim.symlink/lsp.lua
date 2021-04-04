local lspconfig = require'lspconfig'
local configs = require'lspconfig/configs'

if not configs.sorbet then
  configs.sorbet = {
    default_config = {
      cmd = {'bundle', 'exec', 'srb', 'tc', '--lsp'};
      filetypes = {'ruby'};
      root_dir = lspconfig.util.root_pattern("sorbet/config");
      settings = {};
    }
  }
end

lspconfig.sorbet.setup{}
