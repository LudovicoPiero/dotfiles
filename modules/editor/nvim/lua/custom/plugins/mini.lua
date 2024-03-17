return {
  "echasnovski/mini.nvim",
  version = false,
  config = function()
    require("mini.ai").setup()
    require("mini.starter").setup()
    require("mini.notify").setup()
  end,
}
