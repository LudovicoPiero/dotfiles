-- lua/plugins/yazi.lua
-- Disable netrw (default file browser)
vim.g.loaded_netrwPlugin = 1
local yazi = require("yazi")

-- Setup
yazi.setup({
  open_for_directories = false,
  keymaps = {
    show_help = "<F1>",
  },
})

-- Keymaps
local map = vim.keymap.set
local opts = { silent = true, noremap = true }

map({ "n", "v" }, "<leader>tf", "<cmd>Yazi<CR>", vim.tbl_extend("force", opts, { desc = "Open yazi at current file" }))
map("n", "<leader>tc", "<cmd>Yazi cwd<CR>", vim.tbl_extend("force", opts, { desc = "Open file manager at CWD" }))
map("n", "<leader>tt", "<cmd>Yazi toggle<CR>", vim.tbl_extend("force", opts, { desc = "Resume last yazi session" }))
