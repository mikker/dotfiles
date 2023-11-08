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
				stimulus_ls = {},
				sorbet = {
					root_dir = require("lspconfig").util.root_pattern("sorbet/config"),
				},
				tailwindcss = {
					filetypes_include = { "slim" },
					settings = {
						tailwindCSS = {
							emmetCompletions = true,
						},
					},
				},
			},
		},
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"stylua",
				"shfmt",
				"rubyfmt",
				"rustywind",
				"sorbet",
				"prettierd",
				"tailwindcss-language-server",
				"typescript-language-server",
			},
		},
	},
}
