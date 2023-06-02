local map = vim.api.nvim_set_keymap
local opts = { silent = true, noremap = true }

map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Telescope
map("n", "<C-g>", ":Telescope live_grep <CR>", opts)
map("n", "<C-w>", ":Telescope find_files <CR>", opts)

-- Nvim-Tree
map("n", "<C-b>", ":NvimTreeFocus <CR>", opts)
map("n", "<C-c>", ":NvimTreeClose <CR>", opts)
map("n", "<C-t>", ":NvimTreeToggle <CR>", opts)

-- Change Buffer
map("n", "<C-1>", ":BufferLineGoToBuffer 1 <CR>", opts)
map("n", "<C-2>", ":BufferLineGoToBuffer 2 <CR>", opts)
map("n", "<C-3>", ":BufferLineGoToBuffer 3 <CR>", opts)
map("n", "<C-4>", ":BufferLineGoToBuffer 4 <CR>", opts)
map("n", "<C-5>", ":BufferLineGoToBuffer 5 <CR>", opts)

-- Resizing panes
map("n", "<Left>", ":vertical resize +1<CR>", opts)
map("n", "<Right>", ":vertical resize -1<CR>", opts)
map("n", "<Up>", ":resize -1<CR>", opts)
map("n", "<Down>", ":resize +1<CR>", opts)

-- Comment Toggle
require("Comment").setup()

map("n", "j", "gj", opts)
map("n", "k", "gk", opts)
map("n", ";", ":", { noremap = true })
