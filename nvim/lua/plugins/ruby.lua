return {
	"tpope/vim-rails",
	"tpope/vim-rake",
	{ "slim-template/vim-slim", dependencies = { "tpope/vim-haml" } },
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

	-- better matchup for ruby
	{ "andymass/vim-matchup" },
	{
		"nvim-treesitter/nvim-treesitter",
		config = function(_, opts)
			opts.matchup = { enable = true, disable = { "ruby" } }
		end,
	},
}
