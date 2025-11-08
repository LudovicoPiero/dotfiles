return {
  "saghen/blink.pairs",
  init = function()
    vim.keymap.set("n", "<leader>tp", function()
      -- Toggle blink pairs mappings
      vim.g.blink_pairs_disabled = not vim.g.blink_pairs_disabled

      local mappings = require("blink.pairs.mappings")
      if vim.g.blink_pairs_disabled then
        mappings.disable()
      else
        mappings.enable()
      end
    end, { desc = "Toggle auto pairs" })
  end,
  opts = {
    mappings = {
      enabled = true,
      pairs = {
        ["'"] = {},
      },
    },
    highlights = {
      enabled = true,
      groups = {
        "BlinkPairsOrange",
        "BlinkPairsPurple",
        "BlinkPairsBlue",
      },
      matchparen = {
        enabled = true,
        group = "MatchParen",
      },
    },
    debug = false,
  },
}
