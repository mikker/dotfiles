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

return {
  {
    "j-hui/fidget.nvim",
    opts = {
      -- options
    },
  },

  -- no bufferline
  { "akinsho/bufferline.nvim", enabled = false },

  -- no indent guides
  { "lukas-reineke/indent-blankline.nvim", enabled = false },

  -- no fancy ui
  { "folke/noice.nvim", enabled = false },
  -- { "stevearc/dressing.nvim", enabled = false },

  -- extend which-key legend
  {
    "folke/which-key.nvim",
    opts = function()
      local wk = require("which-key")
      wk.add({
        { "<leader>m", group = "+rerun" },
        { "<leader>t", group = "+vimtest" },
        { "<leader>v", group = "+nvimrc" },
      })
    end,
  },

  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            -- { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            -- { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            -- { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          header = logo,
        },
      },
      image = {
        enabled = false,
      },
    },
  },
}
