local nvim_lsp = require'nvim_lsp'
local configs = require'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

if not configs.sorbet then
  configs.sorbet = {
    default_config = {
      cmd = {'srb', 'tc', '--lsp', '--enable-all-beta-lsp-features'};
      filetypes = {'ruby'};
      root_dir = util.root_pattern("sorbet/config");
    }
  }
end

nvim_lsp.sorbet.setup{}
