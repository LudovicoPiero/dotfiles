-- lua/plugins/flash.lua
local flash = require("flash")

flash.setup({})

-- Keymaps
local map = vim.keymap.set
map("n", "s", function()
  flash.jump()
end, { desc = "Flash" })
map("n", "S", function()
  flash.treesitter()
end, { desc = "Flash Treesitter" })
map("o", "r", function()
  flash.remote()
end, { desc = "Remote Flash" })
map("o", "R", function()
  flash.treesitter_search()
end, { desc = "Treesitter Search" })
map("c", "<C-s>", function()
  flash.toggle()
end, { desc = "Toggle Flash Search" })
