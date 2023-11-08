return {
	{
		"stevearc/conform.nvim",
		formatters_by_ft = {
			solidity = { "forge" },
			erb = { "erb_format", "rustywind" },
			slim = { "rustywind" },
			ruby = { "rubyfmt" },
		},
		formatters = {
			forge = {
				command = "forge",
				args = { "fmt", "-r", "-" },
				stdin = true,
			},
		},
	},
}
