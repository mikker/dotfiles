return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "MeanderingProgrammer/render-markdown.nvim",
    },
    opts = {
      strategies = {
        chat = {
          adapter = "anthropic",
        },
        inline = {
          adapter = "anthropic",
        },
      },
    },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion Actions" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle CodeCompanion Chat" },
      { "<leader>an", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "New CodeCompanion Chat" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "Inline CodeCompanion" },
      { "<leader>ap", "<cmd>CodeCompanionCmd<cr>", mode = { "n", "v" }, desc = "CodeCompanion Prompt Library" },
      { "<leader>af", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add Selection to Chat" },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "codecompanion" },
  },

  {
    "nvim-mini/mini.diff",
    config = function()
      local diff = require("mini.diff")
      diff.setup({
        -- Disabled by default
        source = diff.gen_source.none(),
      })
    end,
  },

  {
    "HakonHarnes/img-clip.nvim",
    opts = {
      filetypes = {
        codecompanion = {
          prompt_for_file_name = false,
          template = "[Image]($FILE_PATH)",
          use_absolute_path = true,
        },
      },
    },
  },

  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
    },
    -- uncomment the following line to load hub lazily
    --cmd = "MCPHub",  -- lazy load
    build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
    -- uncomment this if you don't want mcp-hub to be available globally or can't use -g
    -- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
    config = function()
      require("mcphub").setup({})
    end,
  },

  {
    "milanglacier/minuet-ai.nvim",
    config = function()
      require("minuet").setup({
        provider = "claude",
        provider_details = {
          model = "claude-sonnet-4-20250514",
        },
        virtualtext = {
          auto_trigger_ft = {},
          keymap = {
            -- accept whole completion
            accept = "<A-A>",
            -- accept one line
            accept_line = "<A-a>",
            -- accept n lines (prompts for number)
            -- e.g. "A-z 2 CR" will accept 2 lines
            accept_n_lines = "<A-z>",
            -- Cycle to prev completion item, or manually invoke completion
            prev = "<A-[>",
            -- Cycle to next completion item, or manually invoke completion
            next = "<A-]>",
            dismiss = "<A-e>",
          },
        },
      })
    end,
  },
}
