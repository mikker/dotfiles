return {
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
}
