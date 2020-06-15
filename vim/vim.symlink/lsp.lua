local nvim_lsp = require'nvim_lsp'

nvim_lsp.tsserver.setup{on_attach=require'completion'.on_attach}
nvim_lsp.cssls.setup{on_attach=require'completion'.on_attach}

local configs = require'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

if not configs.sorbet then
  configs.sorbet = {
    default_config = {
      cmd = {'srb', 'tc', '--lsp'};
      filetypes = {'ruby'};
      root_dir = util.root_pattern("sorbet/config");
    }
  }
end

nvim_lsp.sorbet.setup{on_attach=require'completion'.on_attach}
