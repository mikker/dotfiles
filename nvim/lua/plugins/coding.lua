return {
	{
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			local cmp = require("cmp")
			opts.mapping = cmp.mapping.preset.insert(vim.tbl_deep_extend("force", opts.mapping, {
				["<c-space>"] = vim.NIL,
			}))
		end,
	},
	{ "echasnovski/mini.pairs", enabled = false },
	{ "echasnovski/mini.surround", enabled = false },
	{ "rafamadriz/friendly-snippets", enabled = false },
	{
		"L3MON4D3/LuaSnip",
		config = function()
			require("luasnip.loaders.from_snipmate").lazy_load()
		end,
	},
}
