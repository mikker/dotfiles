return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap["<CR>"] = { "fallback" }
      opts.keymap["<Tab>"] = {
        require("blink.cmp.keymap.presets").get("super-tab")["<Tab>"][1],
        LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
        "fallback",
      }
    end,
  },

  {
    "rafamadriz/friendly-snippets",
    enabled = false,
  },
}
