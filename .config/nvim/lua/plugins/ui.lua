-- lua/plugins/ui.lua

-- 1. TokyoNight Colorscheme
vim.pack.add({ 'https://github.com/folke/tokyonight.nvim' }, { confirm = false })
vim.cmd.colorscheme('tokyonight-night')

-- 2. Bufferline (Tabs)
vim.pack.add({ 'https://github.com/nvim-tree/nvim-web-devicons' }, { confirm = false })
vim.pack.add({ 'https://github.com/akinsho/bufferline.nvim' }, { confirm = false })

require('bufferline').setup({
  options = { separator_style = "thin", diagnostics = "nvim_lsp" },
})

-- Bufferline Keymaps
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>BufferLinePick<cr>", { desc = "Pick Buffer" })

-- 3. Highlight Colors (Colorizer)
vim.pack.add({ 'https://github.com/brenoprata10/nvim-highlight-colors' }, { confirm = false })
require('nvim-highlight-colors').setup({
  render = "background",
  enable_named_colors = true,
  enable_tailwind = true,
})

-- 4. Mini.Statusline
vim.pack.add({ 'https://github.com/echasnovski/mini.statusline' }, { confirm = false })
local statusline = require("mini.statusline")
statusline.setup({
  use_icons = true,
  set_vim_settings = false,
})
statusline.section_location = function()
  return "%2l:%-2v"
end
