return {
	-- { "SmiteshP/nvim-navic", enabled = false },
	{ "akinsho/bufferline.nvim", enabled = false },
	{ "echasnovski/mini.indentscope", enabled = false },
	{ "folke/noice.nvim", enabled = false },
	{
		"folke/which-key.nvim",
		opts = function()
			local wk = require("which-key")
			wk.register({
				mode = { "n", "v" },
				["<leader>m"] = { name = "+rerun" },
				["<leader>r"] = { name = "+tmux runner" },
				["<leader>t"] = { name = "+test" },
				["<leader>v"] = { name = "+nvimrc" },
			})
		end,
	},
	{
		"goolord/alpha-nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
	},
}
