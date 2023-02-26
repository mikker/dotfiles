local function augroup(name)
	return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

local magic_markers = augroup("magic_markers")
vim.api.nvim_create_autocmd("BufLeave", {
	pattern = "*.{erb,html,haml,slim,eex}",
	group = magic_markers,
	command = 'exe "normal! mH"',
})
vim.api.nvim_create_autocmd("BufLeave", {
	pattern = "*.css",
	group = magic_markers,
	command = 'exe "normal! mS"',
})
vim.api.nvim_create_autocmd("BufLeave", {
	pattern = "*.{js,jsx,ts,tsx}",
	group = magic_markers,
	command = 'exe "normal! mJ"',
})
vim.api.nvim_create_autocmd("BufLeave", {
	pattern = "*.{rb,ex,exs}",
	group = magic_markers,
	command = 'exe "normal! mC"',
})
vim.api.nvim_create_autocmd("BufLeave", {
	pattern = "*.yml",
	group = magic_markers,
	command = 'exe "normal! mY"',
})
