return {
  {
    "tokyonight.nvim",
    priority = 1000,
    after = function()
      require("tokyonight").setup({
        styles = {
          comments = { italic = false },
        },
      })

      vim.cmd.colorscheme("tokyonight-storm")
    end,
  },
}
