return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        -- Default linting configuration
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft
    end,
  },
}