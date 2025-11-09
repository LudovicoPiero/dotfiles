return {
  {
    "todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "plenary.nvim" },
    after = function()
      require("todo-comments").setup({ signs = false })
    end,
  },
}
