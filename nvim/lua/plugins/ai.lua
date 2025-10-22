return {
  {
    "folke/sidekick.nvim",
    opts = {
      nes = { enabled = false },
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
        },
        tools = {
          amp = { cmd = { "amp" }, url = "https://ampcode.com/" },
        },
        keys = {
          {
            "<leader>ac",
            function()
              require("sidekick.cli").toggle({ name = "amp", focus = true })
            end,
            desc = "Sidekick Amp Toggle",
            mode = { "n", "v" },
          },
        },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_c, {
        function()
          return " "
        end,
        color = function()
          local status = require("sidekick.status").get()
          if status then
            return status.kind == "Error" and "DiagnosticError" or status.busy and "DiagnosticWarn" or "Special"
          end
        end,
        cond = function()
          local status = require("sidekick.status")
          return status.get() ~= nil
        end,
      })
    end,
  },

  -- {
  --   "sourcegraph/amp.nvim",
  --   branch = "main",
  --   lazy = false,
  --   opts = { auto_start = true, log_level = "info" },
  -- },

  -- {
  --   "olimorris/codecompanion.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "MeanderingProgrammer/render-markdown.nvim",
  --   },
  --   opts = {
  --     strategies = {
  --       chat = {
  --         adapter = "anthropic",
  --       },
  --       inline = {
  --         adapter = "anthropic",
  --       },
  --     },
  --   },
  --   keys = {
  --     { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion Actions" },
  --     { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle CodeCompanion Chat" },
  --     { "<leader>an", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "New CodeCompanion Chat" },
  --     { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "Inline CodeCompanion" },
  --     { "<leader>ap", "<cmd>CodeCompanionCmd<cr>", mode = { "n", "v" }, desc = "CodeCompanion Prompt Library" },
  --     { "<leader>af", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add Selection to Chat" },
  --   },
  -- },
  -- {
  --   "MeanderingProgrammer/render-markdown.nvim",
  --   ft = { "codecompanion" },
  -- },

  -- {
  --   "nvim-mini/mini.diff",
  --   config = function()
  --     local diff = require("mini.diff")
  --     diff.setup({
  --       -- Disabled by default
  --       source = diff.gen_source.none(),
  --     })
  --   end,
  -- },
  --
  -- {
  --   "HakonHarnes/img-clip.nvim",
  --   opts = {
  --     filetypes = {
  --       codecompanion = {
  --         prompt_for_file_name = false,
  --         template = "[Image]($FILE_PATH)",
  --         use_absolute_path = true,
  --       },
  --     },
  --   },
  -- },

  -- {
  --   "ravitemer/mcphub.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
  --   },
  --   -- uncomment the following line to load hub lazily
  --   --cmd = "MCPHub",  -- lazy load
  --   build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
  --   -- uncomment this if you don't want mcp-hub to be available globally or can't use -g
  --   -- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
  --   config = function()
  --     require("mcphub").setup({})
  --   end,
  -- },
}
