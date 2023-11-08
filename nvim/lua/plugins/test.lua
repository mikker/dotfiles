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
	},
}
