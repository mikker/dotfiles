require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- TPOPE IS THE DEFAULT
  use 'tpope/vim-abolish'
  use 'tpope/vim-bundler'
  use 'tpope/vim-commentary'
  use 'tpope/vim-endwise'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-git'
  use 'tpope/vim-projectionist'
  use 'tpope/vim-rails'
  use 'tpope/vim-rake'
  use 'tpope/vim-repeat'
  use 'tpope/vim-rhubarb'
  use 'tpope/vim-speeddating'
  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-vinegar'

  -- FEATURES
  use 'mikker/vim-rerunner'
  use 'AndrewRadev/splitjoin.vim'
  use 'janko-m/vim-test'
  use 'christoomey/vim-tmux-runner'
  use 'jreybert/vimagit'
  use 'junegunn/vim-easy-align'
  use 'junegunn/vim-slash'
  use 'mattn/emmet-vim'
  use 'mbbill/undotree'
  use 'rakr/vim-togglebg'
  use 'whiteinge/diffconflicts'
  use 'wincent/ferret'
  use 'machakann/vim-highlightedyank'
  use { 'prettier/vim-prettier', run = 'yarn install --frozen-lockfile --production' }
  use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/plenary.nvim' } } }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }

  -- FILE TYPES
  use 'etdev/vim-hexcolor'
  use 'jparise/vim-graphql'
  use 'maxmellon/vim-jsx-pretty'
  use 'slim-template/vim-slim'
  use 'tomlion/vim-solidity'
  use 'vim-ruby/vim-ruby'
  use 'vimwiki/vimwiki'
  use 'yuezk/vim-js'
  use 'zackhsi/sorbet.vim'
  use 'pantharshit00/vim-prisma'

  -- WRITING
  use 'junegunn/goyo.vim'
  use 'reedes/vim-pencil'
  use 'junegunn/limelight.vim'

  -- LOOKS
  use { "mcchrish/zenbones.nvim", requires = "rktjmp/lush.nvim" }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- LSP
  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/nvim-lsp-installer' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    }
  }
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }
end)

-- Add dotfiles to runtimepath
vim.opt.runtimepath = "~/.config/nvim,$VIMRUNTIME"

require "basics"
require "mappings"
require "commands"
require "plugin_config"
require "gui"

-- Looks
vim.cmd("colorscheme zenbones")

-- Automatic dark mode on boot
--   <F5> to toggle background
if vim.fn.executable("is-this-dark-mode") then
  vim.fn.system("is-this-dark-mode")
  if vim.v.shell_error == 0 then
    vim.opt.background = "dark"
  else
    vim.opt.background = "light"
  end
end

-- Initialize LSP
local lsp = require('lsp-zero')
lsp.preset('recommended')
lsp.nvim_workspace()
lsp.setup()

require("luasnip.loaders.from_snipmate").lazy_load({ paths = "./snippets" })
