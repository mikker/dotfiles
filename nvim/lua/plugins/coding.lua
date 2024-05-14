return {
	{
		"L3MON4D3/LuaSnip",
		config = function()
			require("luasnip.loaders.from_snipmate").lazy_load()
		end,
		dependencies = {},
	},
	{ "rafamadriz/friendly-snippets", enabled = false },
	{
		"hrsh7th/nvim-cmp",
		opts = function(opts, _)
			opts.completion = {
				autocomplete = {
					completeopt = "menu,menuone,noinsert",
					-- completeopt = "menu,menuone",
				},
			}
		end,
	},

	{ "echasnovski/mini.pairs", enabled = false },

	-- extras
	{
		"zbirenbaum/copilot.lua",
		opts = function(_, opts)
			opts.filetypes = {
				markdown = false,
			}
		end,
	},

	-- additions
	"tpope/vim-abolish", -- :S smart replace
	"tpope/vim-eunuch", -- unix things
	"tpope/vim-fugitive", -- git things
	"tpope/vim-rhubarb", -- github things
	"tpope/vim-projectionist", -- project navigation
	"tpope/vim-endwise", -- auto ends

	{
		"christoomey/vim-tmux-runner",
		init = function()
			vim.g.VtrOrientation = "h"
			vim.g.VtrPercentage = 40
			vim.g.VtrClearBeforeSend = false
		end,
	},
	{
		"mikker/vim-rerunner",
		dev = true,
		cmd = { "Rerun", "RerunWhat" },
		config = function()
			vim.g.rerunner_focus = "TestLast"
		end,
	},

	{
		"olrtg/nvim-emmet",
		config = function()
			vim.keymap.set({ "n", "v" }, "<leader>xe", require("nvim-emmet").wrap_with_abbreviation)
		end,
	},
}
