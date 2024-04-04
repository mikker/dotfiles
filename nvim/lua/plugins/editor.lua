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

	{
		"stevearc/oil.nvim",
		opts = {
			delete_to_trash = true,
			skip_confirm_for_simple_edits = true,
			view_options = {
				show_hidden = true,
				sort = {
					{ "name", "asc" },
					{ "type", "asc" },
				},
			},
		},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "-", "<CMD>Oil<cr>" },
		},
	},
}
