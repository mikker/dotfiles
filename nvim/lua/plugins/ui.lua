return {
	-- no bufferline
	{ "akinsho/bufferline.nvim", enabled = false },

	-- no indent guides
	{ "lukas-reineke/indent-blankline.nvim", enabled = false },
	{
		"echasnovski/mini.indentscope",
		enabled = false,
		-- opts = { draw = { delay = 10, animation = require("mini.indentscope").gen_animation.none() } },
	},

	-- no fancy ui
	{ "folke/noice.nvim", enabled = false },

	-- extend whick-key legend
	{
		"folke/which-key.nvim",
		opts = function()
			local wk = require("which-key")
			wk.register({
				mode = { "n", "v" },
				["<leader>m"] = { name = "+rerun" },
				["<leader>t"] = { name = "+vimtest" },
				["<leader>v"] = { name = "+nvimrc" },
			})
		end,
	},

	{
		"nvimdev/dashboard-nvim",
		opts = function()
			local logo = [[
                        .:-====--:.                
                    .-++          =++-:            
                  -++:               :=+=:         
     .-=+++====+**#*=-:.                .=*-       
   .++:.       :*-:+*+-=++=-.             .++      
  .*=         :*:   .=*-  .:-++=:           =*     
  -#         .*-       -++-.   :=++:         *-    
  .*-        ++          .-=++-:...-++:      *=    
   .=*=:..  :#.               .:-=+++***=.   #-    
      .:-=+***.          .::::          :*+.=*     
         =*=--=++-     -*=-::-++-....:::--+##:     
       .*=       +*+++#=       .+*=---:::-#+=+*:   
       +*        *:  -#         :#.           -*   
       =*       =+   :#.        -*            :#   
        =*-.   :*.    -*-     .=*:            ++   
          -=**+*=       -+++++=:            .++    
    ]]

			logo = string.rep("\n", 4) .. logo .. "\n\n"

			local opts = {
				theme = "doom",
				hide = {
					-- this is taken care of by lualine
					-- enabling this messes up the actual laststatus setting after loading a file
					statusline = false,
				},
				config = {
					header = vim.split(logo, "\n"),
        -- stylua: ignore
        center = {
          { action = "Telescope find_files",                                     desc = " Find file",       icon = " ", key = "f" },
          -- { action = "ene | startinsert",                                        desc = " New file",        icon = " ", key = "n" },
          { action = "Telescope oldfiles",                                       desc = " Recent files",    icon = " ", key = "r" },
          -- { action = "Telescope live_grep",                                      desc = " Find text",       icon = " ", key = "g" },
          -- { action = [[lua require("lazyvim.util").telescope.config_files()()]], desc = " Config",          icon = " ", key = "c" },
          -- { action = 'lua require("persistence").load()',                        desc = " Restore Session", icon = " ", key = "s" },
          -- { action = "LazyExtras",                                               desc = " Lazy Extras",     icon = " ", key = "x" },
          { action = "Lazy",                                                     desc = " Lazy",            icon = "󰒲 ", key = "l" },
          { action = "qa",                                                       desc = " Quit",            icon = " ", key = "q" },
        },
					footer = function()
						local stats = require("lazy").stats()
						local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
						return {
							"💤 Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
						}
					end,
				},
			}

			for _, button in ipairs(opts.config.center) do
				button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
				button.key_format = "  %s"
			end

			-- close Lazy and re-open when the dashboard is ready
			if vim.o.filetype == "lazy" then
				vim.cmd.close()
				vim.api.nvim_create_autocmd("User", {
					pattern = "DashboardLoaded",
					callback = function()
						require("lazy").show()
					end,
				})
			end

			return opts
		end,
	},

	-- zen mode
	{
		"Pocco81/true-zen.nvim",
		keys = {
			{ "<leader>uz", "<cmd>TZAtaraxis<cr>", desc = "Toggle zen mode" },
		},
		config = function()
			require("true-zen").setup({
				modes = {
					ataraxis = {
						callbacks = {
							open_pre = function()
								require("lualine").hide({ place = { "statusline" }, unhide = false })
							end,
							close_pos = function()
								require("lualine").hide({ place = { "statusline" }, unhide = true })
							end,
						},
					},
				},
			})
		end,
	},
}
