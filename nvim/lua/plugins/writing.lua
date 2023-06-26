return {
	"junegunn/goyo.vim",
	{
		"reedes/vim-pencil",
		config = function()
			vim.cmd([[
	augroup pencil
	  autocmd!
	  autocmd FileType markdown,mkd,text call pencil#init()
	augroup END
	]])

			vim.g["pencil#wrapModeDefault"] = "soft"
			vim.g["pencil#conceallevel"] = 0
			vim.g["pencil#concealcursor"] = "c"
		end,
	},
	"junegunn/limelight.vim",
}
