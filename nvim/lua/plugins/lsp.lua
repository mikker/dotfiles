return {
	"jose-elias-alvarez/null-ls.nvim",
	opts = function()
		local nls = require("null-ls")
		return {
			sources = {
				nls.builtins.formatting.prettier,
				nls.builtins.formatting.stylua,
			},
		}, {
			"hrsh7th/cmp-nvim-lsp",
			keys = {
				{ "<c-space>", false },
			},
		}
	end,
}
