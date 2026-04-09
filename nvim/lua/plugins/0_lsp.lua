local util = require("lspconfig.util")

return {
  {
    "neovim/nvim-lspconfig",
    -- init = function()
    --   local keys = require("lazyvim.plugins.lsp.keymaps").get()
    --   keys[#keys + 1] = { "[w", false }
    --   keys[#keys + 1] = { "]w", false }
    -- end,
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        lunte = {},
        tailwindcss = {
          filetypes_include = { "ruby", "eruby" },
          settings = {
            tailwindCSS = {
              includeLanguages = {
                erb = "html",
                eruby = "html",
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
    root_dir = function(bufnr, on_dir)
      local root_files = {
        -- Rails
        "app/assets/stylesheets/application.tailwind.css",
        "app/assets/tailwind/application.css",
      }
      local fname = vim.api.nvim_buf_get_name(bufnr)
      root_files = util.insert_package_json(root_files, "tailwindcss", fname)
      on_dir(vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1]))
    end,
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "rubocop",
        "tailwindcss-language-server",
        "typescript-language-server",
        "herb-language-server",
        "eslint-lsp",
      },
    },
  },

  -- mason-lspconfig.nvim
}
