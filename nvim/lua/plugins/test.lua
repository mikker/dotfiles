return {
	{
		"nvim-neotest/neotest",
		opts = {
			-- output = { open_on_run = true },
			-- output_panel = { open = "botright vsplit" },
			quickfix = { open = false },
			jump = { enabled = false },
		},
	},
	--
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

	let test#strategy = "vtr"

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
