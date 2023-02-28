return {
	{
		"vimwiki/vimwiki",
		lazy = false,
		init = function(_)
			print("hi")
			vim.cmd([[
      let g:vimwiki_list = [{ 'path': '~/Library/Mobile Documents/27N4MQEA55~pro~writer/Documents/', 'syntax': 'markdown', 'ext': '.md' }]
      let g:vimwiki_global_ext = 0
      ]])
		end,
	},
}
