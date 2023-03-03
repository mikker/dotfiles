return {
	{
		"neovim/nvim-lspconfig",
		init = function()
			local keys = require("lazyvim.plugins.lsp.keymaps").get()
			keys[#keys + 1] = { "[w", false }
			keys[#keys + 1] = { "]w", false }
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		opts = function()
			local nls = require("null-ls")

			local h = require("null-ls.helpers")
			local forge_source = {
				name = "forge",
				method = nls.methods.FORMATTING,
				filetypes = { "solidity" },
				generator = h.formatter_factory({
					command = "forge",
					args = { "fmt", "-r", "-" },
					to_stdin = true,
				}),
			}

			return {
				sources = {
					nls.builtins.formatting.prettier,
					nls.builtins.formatting.stylua,
					forge_source,
				},
			}, {
				"hrsh7th/cmp-nvim-lsp",
				keys = {
					{ "<c-space>", false },
				},
			}
		end,
	},
}
