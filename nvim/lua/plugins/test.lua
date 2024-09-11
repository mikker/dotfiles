return {
  {
    "janko-m/vim-test",
    init = function()
      vim.cmd([[
		" Use :TT for vim-test
		fun! TTStrategy(cmd)
		  execute 'TT ' . a:cmd
		endfun

		let g:test#custom_strategies = { "tt": function('TTStrategy') }

	  let test#strategy = "tt"
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
    keys = {
      { "<leader>tt", "<cmd>TestNearest<cr>", { desc = "Test nearest", silent = true } },
      { "<leader>tT", "<cmd>TestFile<cr>", { desc = "Test file", silent = true } },
      { "<leader>ta", "<cmd>TestSuite<cr>", { desc = "Test suite", silent = true } },
      { "<leader>tl", "<cmd>TestLast<cr>", { desc = "Test last", silent = true } },
      { "<leader>tg", "<cmd>TestVisit<cr>", { dest = "Go to last tested", silent = true } },
    },
  },
}
