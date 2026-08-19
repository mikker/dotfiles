return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ruby = { "rubocop", "rustywind" },
        css = { "prettier" },
      },
      formatters = {
        rubocop = {
          command = require("conform.util").find_executable({ "bin/rubocop" }, "rubocop"),
          cwd = require("conform.util").root_file({ ".rubocop.yml", "Gemfile" }),
        },
      },
    },
  },

  -- mason.nvim
}
