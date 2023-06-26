return {
	-- TPOPE IS THE DEFAULT
	"tpope/vim-abolish",
	"tpope/vim-eunuch",
	"tpope/vim-fugitive",
	"tpope/vim-projectionist",
	"tpope/vim-rhubarb",
	"tpope/vim-vinegar",
	"tpope/vim-surround",
	-- "tpope/vim-speeddating",

	{
		"Pocco81/true-zen.nvim",
		keys = {
			{ "<leader>uz", "<cmd>TZAtaraxis<cr>", desc = "Toggle zen mode" },
		},
		config = function()
			require("true-zen").setup({
				modes = {
					ataraxis = {
						callbacks = {
							open_pre = function()
								require("lualine").hide({})
							end,
							close_pos = function()
								require("lualine").hide({ unhide = true })
							end,
						},
					},
				},
			})
		end,
	},

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

	"echasnovski/mini.bracketed",
	{
		"echasnovski/mini.splitjoin",
		init = function()
			require("mini.splitjoin").setup({})
		end,
	},
	"whiteinge/diffconflicts",
	"junegunn/vim-easy-align",
	"mattn/emmet-vim",
	"mbbill/undotree",
}
