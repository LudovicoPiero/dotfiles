return {
  "akinsho/bufferline.nvim",
  init = function()
    vim.keymap.set("n", "<Tab>", ":BufferLinePick<CR>", { silent = true })
    -- vim.keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true })
    -- vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { silent = true })
  end,
  config = function()
    local bufferline = require("bufferline")
    bufferline.setup({
      -- highlights = require("catppuccin.special.bufferline").get_theme(),
      options = {
        show_close_icon = false,
        show_buffer_close_icons = false,
        separator_style = "thin",
        diagnostics = "nvim_lsp",
        themable = true,
        pick = {
          alphabet = "abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ1234567890",
        },
      },
    })
  end,
}
