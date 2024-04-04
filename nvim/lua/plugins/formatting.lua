return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				solidity = { "forge" },
				eruby = { "erb_format", "rustywind" },
				slim = { "rustywind" },
				ruby = { "rubyfmt", "rustywind" },
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
					condition = function(ctx)
						local basename = vim.fs.basename(ctx.filename)
						if basename and string.match(basename, ".yml$") then
							return false
						end
						return true
					end,
				},
			},
		},
	},
}
