require("catppuccin").setup()

vim.g.catppuccin_flavour = "mocha"
vim.cmd([[colorscheme catppuccin]])

-- set lightline theme to horizon
vim.g.lightline = { colorscheme = "catppuccin" }
