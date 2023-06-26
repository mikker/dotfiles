return {
	{
		"neovim/nvim-lspconfig",
		init = function()
			local keys = require("lazyvim.plugins.lsp.keymaps").get()
			keys[#keys + 1] = { "[w", false }
			keys[#keys + 1] = { "]w", false }
		end,
		opts = {
			servers = {
				sorbet = {
					root_dir = require("lspconfig").util.root_pattern("sorbet/config"),
				},
				tailwindcss = {
					includeLanguages = {
						plaintext = "slim",
					},
					emmetCompletions = true,
				},
			},
		},
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		opts = function()
			local null_ls = require("null-ls")

			local h = require("null-ls.helpers")
			local forge_source = {
				name = "forge",
				method = null_ls.methods.FORMATTING,
				filetypes = { "solidity" },
				generator = h.formatter_factory({
					command = "forge",
					args = { "fmt", "-r", "-" },
					to_stdin = true,
				}),
			}

			return {
				sources = {
					-- null_ls.builtins.diagnostics.erb_lint,
					null_ls.builtins.formatting.erb_format.with({
						disabled_filetypes = { "eruby.yaml" },
					}),
					null_ls.builtins.formatting.rubyfmt,
					null_ls.builtins.formatting.prettierd,
					null_ls.builtins.formatting.stylua,
					forge_source,
				},
			}
		end,
	},
}
