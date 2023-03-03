return {
	{
		"vimwiki/vimwiki",
		init = function(_)
			print("hi")
			vim.cmd([[
      let g:vimwiki_list = [{ 'path': '~/Library/Mobile Documents/27N4MQEA55~pro~writer/Documents/', 'syntax': 'markdown', 'ext': '.md' }]
      let g:vimwiki_global_ext = 0
      ]])
		end,
		cmd = "VimwikiIndex",
		keys = {
			["<leader>ww"] = ":VimwikiIndex<cr>",
		},
	},
}
