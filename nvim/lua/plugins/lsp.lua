local util = require("lspconfig.util")

return {
  {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- optional
      "neovim/nvim-lspconfig", -- optional
    },
    opts = {}, -- your configuration
  },
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "[w", false }
      keys[#keys + 1] = { "]w", false }
    end,
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        tailwindcss = {
          filetypes_include = { "slim", "ruby", "eruby" },
          settings = {
            tailwindCSS = {
              includeLanguages = {
                slim = "html",
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
        -- Generic
        "tailwind.config.js",
        "tailwind.config.cjs",
        "tailwind.config.mjs",
        "tailwind.config.ts",
        "postcss.config.js",
        "postcss.config.cjs",
        "postcss.config.mjs",
        "postcss.config.ts",
        -- Phoenix
        "assets/tailwind.config.js",
        "assets/tailwind.config.cjs",
        "assets/tailwind.config.mjs",
        "assets/tailwind.config.ts",
        -- Django
        "theme/static_src/tailwind.config.js",
        "theme/static_src/tailwind.config.cjs",
        "theme/static_src/tailwind.config.mjs",
        "theme/static_src/tailwind.config.ts",
        -- Rails
        "app/assets/stylesheets/application.tailwind.css",
        "app/assets/tailwind/application.css",
      }
      local fname = vim.api.nvim_buf_get_name(bufnr)
      root_files = util.insert_package_json(root_files, "tailwindcss", fname)
      root_files = util.root_markers_with_field(root_files, { "mix.lock" }, "tailwind", fname)
      on_dir(vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1]))
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "rubyfmt",
        "rustywind",
        "tailwindcss-language-server",
        "typescript-language-server",
        "erb-formatter",
        "eslint-lsp",
      },
    },
  },
}
