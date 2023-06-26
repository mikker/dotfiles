return {
	"tpope/vim-rails",
	"tpope/vim-rake",
	"slim-template/vim-slim",
	"vim-ruby/vim-ruby",
	"zackhsi/sorbet.vim",

	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"ruby",
			})
		end,
	},
	{
		"nvim-neotest/neotest",
		dependencies = { "olimorris/neotest-rspec", "zidhuss/neotest-minitest" },
		opts = {
			adapters = {
				["neotest-rspec"] = {
					rspec_cmd = function()
						return vim.tbl_flatten({
							"bundle",
							"exec",
							"rspec",
						})
					end,
				},
				["neotest-minitest"] = {},
			},
		},
	},
}
