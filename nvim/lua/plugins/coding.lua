return {
	{
		"L3MON4D3/LuaSnip",
		config = function()
			require("luasnip.loaders.from_snipmate").lazy_load()
		end,
		dependencies = {},
	},

	{
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			local cmp = require("cmp")
			opts.mapping = cmp.mapping.preset.insert(vim.tbl_deep_extend("force", opts.mapping, {
				["<C-Space>"] = vim.NIL,
				["<CR>"] = vim.NIL,
				["<Right>"] = cmp.mapping.confirm({ select = false }),
			}))
		end,
	},

	{ "echasnovski/mini.pairs", enabled = false },
	{
		"echasnovski/mini.surround",
		opts = {
			-- tpope/vim-surround style mappings
			mappings = {
				add = "ys",
				delete = "ds",
				find = nil,
				highlight = nil,
				replace = "cs",
				update_n_lines = nil,
			},
		},
	},

	-- additions
	"tpope/vim-abolish", -- :S smart replace
	"tpope/vim-eunuch", -- unix things
	"tpope/vim-fugitive", -- git things
	"tpope/vim-rhubarb", -- github things
	"tpope/vim-projectionist", -- project navigation
	"tpope/vim-vinegar", -- fs navigation
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

	"mattn/emmet-vim",
}
