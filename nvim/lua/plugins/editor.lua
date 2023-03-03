return {
	"echasnovski/mini.bracketed",

	-- TPOPE IS THE DEFAULT
	"tpope/vim-abolish",
	"tpope/vim-eunuch",
	"tpope/vim-fugitive",
	"tpope/vim-projectionist",
	"tpope/vim-rhubarb",
	"tpope/vim-speeddating",
	"tpope/vim-vinegar",
	"tpope/vim-surround",

	"AndrewRadev/splitjoin.vim",
	"NvChad/nvim-colorizer.lua",
	"junegunn/vim-easy-align",
	"mattn/emmet-vim",
	"mbbill/undotree",
	"whiteinge/diffconflicts",

	{
		"nvim-telescope/telescope.nvim",
		keys = {
			{ "<leader><space>", false },
		},
	},

	-- Rerunner/Test/Tmux
	{
		"mikker/vim-rerunner",
		dev = true,
		cmd = { "Rerun", "RerunWhat" },
		config = function()
			vim.g.rerunner_focus = "TestLast"
		end,
	},
	{
		"christoomey/vim-tmux-runner",
		init = function()
			vim.g.VtrOrientation = "h"
			vim.g.VtrPercentage = 40
			vim.g.VtrClearBeforeSend = false
		end,
	},
	{
		"janko-m/vim-test",
		init = function()
			vim.cmd([[
" Use :TT for vim-test
fun! TTStrategy(cmd)
  execute 'TT ' . a:cmd
endfun

let g:test#custom_strategies = { "tt": function('TTStrategy') }

if has('nvim')
  let test#strategy = "tt"
else
  let test#strategy = "basic"
endif

" let test#strategy = "vtr"

let test#custom_runners = {'Solidity': ['Forge']}

let test#solidity#patterns = {
  \ 'test': [
    \ '\v^\s*function (test[^(]+)',
    \ ],
  \ 'namespace': [
    \ '\v^\s*contract (\S+)',
    \ ]
  \ }
]])
		end,
	},
}
