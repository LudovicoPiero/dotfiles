return {
  "echasnovski/mini.nvim",
  version = false,
  config = function()
    require("mini.starter").setup()
    require("mini.animate").setup()
    require("mini.ai").setup()
  end,
}
