return {
	{
		"folke/which-key.nvim",
		optional = true,
		opts = {
			defaults = {
				["<leader>a"] = { name = "+ai" },
			},
		},
	},
	{
		"jackMort/ChatGPT.nvim",
		event = "VeryLazy",
		config = function()
			require("chatgpt").setup({
				openai_params = {
					model = "gpt-4",
				},
			})
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{
				"<leader>ac",
				function()
					require("chatgpt").edit_with_instructions()
				end,
				desc = "ChatGPT",
			},
		},
	},
}
