return {
	-- { "nvim-neo-tree/neo-tree.nvim", enabled = false },
	{
		"nvim-telescope/telescope.nvim",
		keys = {
			{ "<leader><space>", false },
		},
	},
	{ "ggandor/flit.nvim", enabled = false },
	{ "ggandor/leap.nvim", enabled = false },
	{
		"lewis6991/gitsigns.nvim",
		opts = { signcolumn = false },
	},
	-- { "RRethy/vim-illuminate", enabled = false },
}
