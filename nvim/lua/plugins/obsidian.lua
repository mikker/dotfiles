return {
	"epwalsh/obsidian.nvim",
	lazy = true,
	ft = "markdown",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open Obisidian.app" },
		{ "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New note" },
		{ "<leader>of", "<cmd>ObsidianQuickSwitch<cr>", desc = "Find note by name" },
		{ "<leader>og", "<cmd>ObsidianSearch<cr>", desc = "Grep notes" },
		{ "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Open today's daily note" },
	},
	opts = {
		workspaces = {
			{
				name = "Wiki",
				path = "/Users/mikker/Library/Mobile Documents/iCloud~md~obsidian/Documents/Wiki",
				overrides = {
					daily_notes = {
						folder = "02 Calendar/Journals/",
					},
				},
			},
		},
	},
}
