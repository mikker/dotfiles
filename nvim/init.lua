local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
	{
		"LazyVim/LazyVim",
		import = "lazyvim.plugins",
		opts = { colorscheme = "zenwritten" },
	},
	{ import = "lazyvim.plugins.extras.coding.copilot" },
	{ import = "lazyvim.plugins.extras.coding.yanky" },
	{ import = "lazyvim.plugins.extras.formatting.prettier" },
	{ import = "lazyvim.plugins.extras.lang.tailwind" },
	{ import = "lazyvim.plugins.extras.lang.typescript" },
	{ import = "lazyvim.plugins.extras.linting.eslint" },
	{ import = "lazyvim.plugins.extras.test.core" },
	{ import = "lazyvim.plugins.extras.util.mini-hipatterns" },
	-- { import = "lazyvim.plugins.extras.editor.flash" },
	{ import = "plugins" },
}, {
	dev = {
		path = "~/dev",
		patterns = { "mikker" },
		fallback = true,
	},
})

require("commands")
