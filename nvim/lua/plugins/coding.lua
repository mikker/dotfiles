return {
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      -- local defaults = require("cmp.config.default")
      local auto_select = false
      return {
        auto_brackets = {},
        completion = {
          completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
        },
        preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = LazyVim.cmp.confirm({ select = auto_select }),
          ["<Tab>"] = LazyVim.cmp.confirm({ select = true }),
          -- ["<C-l>"] = LazyVim.cmp.confirm({ select = true }),
          ["<S-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "copilot" },
          { name = "snippets" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
        formatting = {
          format = function(_, item)
            local icons = LazyVim.config.icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end

            local widths = {
              abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
              menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
            }

            for key, width in pairs(widths) do
              if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
              end
            end

            return item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        -- sorting = defaults.sorting,
      }
    end,
  },

  {
    "garymjr/nvim-snippets",
    opts = {
      friendly_snippets = false,
      -- search_paths = { "/Users/mikker/.config/nvim/snippets" },
    },
    keys = {
      {
        "<Tab>",
        "<cmd>lua require('cmp').complete()<CR>",
        { noremap = true, expr = false, silent = true, mode = "i" },
      },
    },
  },
  { "rafamadriz/friendly-snippets", enabled = false },

  { "echasnovski/mini.pairs", enabled = false },

  -- extras
  {
    "zbirenbaum/copilot.lua",
    opts = function(_, opts)
      opts.suggestion = { enabled = true }
      opts.filetypes = {
        markdown = false,
      }
    end,
  },
  {},

  -- additions
  "tpope/vim-abolish", -- :S smart replace
  "tpope/vim-eunuch", -- unix things
  "tpope/vim-fugitive", -- git things
  "tpope/vim-rhubarb", -- github things
  "tpope/vim-projectionist", -- project navigation
  "tpope/vim-endwise", -- auto ends

  {
    "christoomey/vim-tmux-runner",
    init = function()
      vim.g.VtrOrientation = "h"
      vim.g.VtrPercentage = 40
      vim.g.VtrClearBeforeSend = false
    end,
    keys = {
      { "<leader>ro", ":VtrOpenRunner<cr>", desc = "Open Tmux runner" },
      { "<leader>rk", ":VtrKillRunner<cr>", desc = "Kill Tmux runner" },
    },
  },
  {
    "mikker/vim-rerunner",
    dev = true,
    cmd = { "Rerun", "RerunWhat" },
    keys = {
      { "<cr>", "<cmd>Rerun<cr>", desc = "Run", mode = "n" },
    },
    config = function()
      vim.g.rerunner_focus = "TestLast"
    end,
  },

  "mattn/emmet-vim",
}
