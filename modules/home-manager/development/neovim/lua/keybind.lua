local map = vim.api.nvim_set_keymap
local opts = {silent = true, noremap = true}

map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Telescope
map("n", "<C-g>", ":Telescope live_grep <CR>", opts)
map("n", "<C-w>", ":Telescope find_files <CR>", opts)

-- Nvim-Tree
map("n", "<C-b>", ":NvimTreeFocus <CR>", opts)
map("n", "<C-t>", ":NvimTreeToggle <CR>", opts)

-- Comment Toggle
require("Comment").setup()
-- map("n", "<C-c>", ":CommentToggle <CR>", opts)

map("n", "j", "gj", opts)
map("n", "k", "gk", opts)
map("n", ";", ":", {noremap = true})
