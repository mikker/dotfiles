return {
  {
    "robitx/gp.nvim",
    config = function()
      local conf = {
        openai_api_key = os.getenv("OPENAI_API_KEY"),
      }
      require("gp").setup(conf)

      -- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    cmd = "CopilotChat",
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        auto_insert_mode = true,
        model = "claude-3.7-sonnet",
        question_header = "  " .. user .. " ",
        answer_header = "  Copilot ",
        window = {
          width = 0.4,
        },
      }
    end,
    keys = {
      {
        "<leader>ar",
        function()
          return require("CopilotChat").reset()
        end,
      },
    },
  },

  -- {
  --   "zbirenbaum/copilot.lua",
  --   opts = {
  --     filetypes = {
  --       markdown = false,
  --     },
  --   },
  -- },
}
