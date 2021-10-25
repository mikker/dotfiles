require'lspinstall'.setup() -- important

local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  require'lspconfig'[server].setup{}
end

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

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

-- local saga = require 'lspsaga'
-- saga.init_lsp_saga()


