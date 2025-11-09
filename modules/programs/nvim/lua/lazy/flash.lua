return {
  "flash.nvim",
  after = function()
    require("flash").setup({})
  end,

  keys = {
      -- stylua: ignore start
      { "s", mode = "n", function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = "n", function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = "o", function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = "c", function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    -- stylua: ignore end
  },
}
