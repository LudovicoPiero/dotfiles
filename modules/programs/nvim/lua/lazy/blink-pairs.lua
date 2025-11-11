return {
  "blink.pairs",
  after = function()
    require("blink.pairs").setup({
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
    })
  end,

  keys = {
    {
      "<leader>tp",
      mode = "n",
      function()
        -- Toggle blink pairs mappings
        vim.g.blink_pairs_disabled = not vim.g.blink_pairs_disabled

        local mappings = require("blink.pairs.mappings")
        if vim.g.blink_pairs_disabled then
          mappings.disable()
        else
          mappings.enable()
        end
      end,
      desc = "[T]oggle auto [P]airs",
    },
  },
}
