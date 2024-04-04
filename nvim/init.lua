local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
	{
		"LazyVim/LazyVim",
		opts = { colorscheme = "zenbones" },
		import = "lazyvim.plugins",
	},
	{ import = "plugins" },
}, {
	checker = { enabled = true },
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				-- "matchit",
				-- "matchparen",
				-- "netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	dev = {
		path = "~/dev",
		patterns = { "mikker" },
		fallback = true,
	},
})

require("commands")
