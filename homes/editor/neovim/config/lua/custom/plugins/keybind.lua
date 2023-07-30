local map = vim.api.nvim_set_keymap
local opts = { silent = true, noremap = true }

local keymaps = {
    -- Split navigation
    map("n", "<C-h>", "<C-w>h", opts),
    map("n", "<C-j>", "<C-w>j", opts),
    map("n", "<C-k>", "<C-w>k", opts),
    map("n", "<C-l>", "<C-w>l", opts),

    -- Hop
    map("n", "s", ":HopWord <CR>", opts),
    map("n", "S", ":HopLine <CR>", opts),
    map("n", "<C-s>", ":HopPattern <CR>", opts),

    -- Telescope
    map("n", "<C-g>", ":Telescope live_grep <CR>", opts),
    map("n", "<C-e>", ":Telescope find_files <CR>", opts),
}

return keymaps
