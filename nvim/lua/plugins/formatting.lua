return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				solidity = { "forge" },
				eruby = { "erb-format", "rustywind" },
				slim = { "rustywind" },
				ruby = { "rubyfmt", "rustywind" },
				yaml = {},
			},
			formatters = {
				forge = {
					command = "forge",
					args = { "fmt", "-r", "-" },
					stdin = true,
				},
				erb_format = {
					command = "erb-format",
					args = { "--stdin" },
					stdin = true,
				},
			},
		},
	},
}
