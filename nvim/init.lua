local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("commands")

require("lazy").setup({
	{
		"LazyVim/LazyVim",
		import = "lazyvim.plugins",
		opts = {
			colorscheme = "zenbones",
			defaults = {
				options = false,
				keymaps = false,
			},
		},
	},
	{ import = "lazyvim.plugins.extras.lang.typescript" },
	{ import = "plugins" },
}, {
	dev = {
		path = "~/dev",
		patterns = { "mikker" },
		fallback = true,
	},
})
