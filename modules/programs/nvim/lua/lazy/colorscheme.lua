return {
  "tokyonight.nvim",
  priority = 1000, -- Make sure to load this before all the other start plugins.
  after = function()
    ---@diagnostic disable-next-line: missing-fields, param-type-not-match
    require("tokyonight").setup({
      styles = {
        comments = { italic = false },
      },
    })

    vim.cmd.colorscheme("tokyonight-storm")
  end,
}
