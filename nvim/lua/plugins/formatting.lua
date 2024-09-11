return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        solidity = { "forge" },
        eruby = { "erb_format", "rustywind" },
        slim = { "rustywind" },
        ruby = { "rubyfmt", "rustywind" },
        yaml = {},
        -- Disable erb_format for YAML files
        ["eruby.yaml"] = { "rustywind" },
      },
      formatters = {
        forge = {
          command = "forge",
          args = { "fmt", "-r", "-" },
          stdin = true,
        },
      },
    },
  },
}
