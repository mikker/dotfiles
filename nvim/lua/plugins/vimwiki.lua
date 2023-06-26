return {
	{
		"vimwiki/vimwiki",
		init = function(_)
			vim.g.wiki_path = "~/Library/Mobile Documents/27N4MQEA55~pro~writer/Documents/"
			vim.g.vimwiki_list = { { path = vim.g.wiki_path, syntax = "markdown", ext = ".md" } }
			vim.g.vimwiki_global_ext = 0
		end,
		keys = {
			{ "<leader>ww", "<cmd>VimwikiIndex<cr>", desc = "Open Vimwiki index" },
		},
	},
}
