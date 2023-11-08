return {
	{ "nvim-neo-tree/neo-tree.nvim", enabled = false },
	{
		"nvim-telescope/telescope.nvim",
		keys = {
			{ "<leader><space>", false },
		},
		opts = {
			defaults = {
				mappings = {
					i = {
						["<c-t>"] = require("telescope.actions").select_tab,
					},
				},
			},
		},
	},
	{ "folke/flash.nvim", enabled = false },

	{ "lewis6991/gitsigns.nvim", enabled = false },

	-- additions
	{
		"echasnovski/mini.splitjoin",
		init = function()
			require("mini.splitjoin").setup({})
		end,
	},
	"junegunn/vim-easy-align",
	"echasnovski/mini.bracketed",
	"mbbill/undotree",
	"whiteinge/diffconflicts",
}
