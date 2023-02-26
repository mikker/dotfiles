return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function()
			return {
				options = {
					icons_enabled = true,
					section_separators = "",
					component_separators = "",
				},

				sections = {
					lualine_a = { "mode", "paste" },
					lualine_b = { "branch", "diff" },
					lualine_c = { "readonly", { "filename", path = 1 } },

					lualine_x = { "filetype" },
					lualine_y = { "diagnostics" },
					lualine_z = {},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },

					lualine_x = { "filetype" },
					lualine_y = {},
					lualine_z = {},
				},
			}
		end,
	},
}
