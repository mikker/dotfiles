return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "[w", false }
      keys[#keys + 1] = { "]w", false }
    end,
    opts = {
      -- inlay_hints = { enabled = false },
      servers = {
        stimulus_ls = {},
        sorbet = {
          root_dir = require("lspconfig").util.root_pattern("sorbet/config"),
        },
        tailwindcss = {
          filetypes_include = { "slim", "ruby", "eruby" },
          settings = {
            tailwindCSS = {
              includeLanguages = {
                slim = "html",
                erb = "html",
                ruby = "html",
              },
              emmetCompletions = true,
              experimental = {
                classRegex = {
                  "\\bclass:\\s*['\"]([^'\"]*)['\"]",
                  "\\b(class_names|tokens)[\\(|\\s]\\s*['\"]([^'\"]*)['\"]",
                  "\\b(CL|ClassList\\.new)[\\(|\\s]\\s*['\"]([^'\"]*)['\"]",
                },
              },
            },
          },
        },
      },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "rubyfmt",
        "rustywind",
        "sorbet",
        "prettierd",
        "tailwindcss-language-server",
        "typescript-language-server",
        "erb-formatter",
        "eslint-lsp",
      },
    },
  },
}
