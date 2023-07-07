return {
	-- { "SmiteshP/nvim-navic", enabled = false },
	{ "akinsho/bufferline.nvim", enabled = false },
	-- {
	-- 	"nvim-lualine/lualine.nvim",
	-- 	event = "VeryLazy",
	-- 	opts = function()
	-- 		return {
	-- 			options = {
	-- 				icons_enabled = true,
	-- 				section_separators = "",
	-- 				component_separators = "",
	-- 			},
	--
	-- 			-- sections = {
	-- 			-- 	lualine_a = { "mode", "paste" },
	-- 			-- 	lualine_b = { "branch", "diff" },
	-- 			-- 	lualine_c = { "readonly", { "filename", path = 1 } },
	-- 			--
	-- 			-- 	lualine_x = { "filetype" },
	-- 			-- 	lualine_y = { "diagnostics" },
	-- 			-- 	lualine_z = {},
	-- 			-- },
	-- 			-- inactive_sections = {
	-- 			-- 	lualine_a = {},
	-- 			-- 	lualine_b = {},
	-- 			-- 	lualine_c = { "filename" },
	-- 			--
	-- 			-- 	lualine_x = { "filetype" },
	-- 			-- 	lualine_y = {},
	-- 			-- 	lualine_z = {},
	-- 			-- },
	-- 		}
	-- 	end,
	-- },
	-- { "lukas-reineke/indent-blankline.nvim", enabled = false },
	{ "echasnovski/mini.indentscope", enabled = false },
	-- { "folke/noice.nvim", enabled = false },
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
