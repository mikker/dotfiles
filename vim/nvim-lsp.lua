local nvim_lsp = require'nvim_lsp'
local skeleton = require'nvim_lsp/skeleton'

-- Check if it's already defined for when I reload this file.
if not nvim_lsp.sorbet then
  skeleton.sorbet = {
    default_config = {
      cmd = {'bundle', 'exec', 'srb', 'tc', '--lsp'};
      filetypes = {'ruby'};
      root_dir = nvim_lsp.util.root_pattern("sorbet/config");
      log_level = vim.lsp.protocol.MessageType.Debug;
      settings = {};
    };
  }
end

nvim_lsp.sorbet.setup { }

nvim_lsp.solargraph.setup{settings = {
  diagnostics = true,
  useBundler = true
}}
nvim_lsp.tsserver.setup{}
