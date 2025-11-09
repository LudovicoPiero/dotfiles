return {
  {
    "bufferline.nvim",
    before = function()
      vim.keymap.set("n", "<Tab>", ":BufferLinePick<CR>", { silent = true })
      -- vim.keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true })
      -- vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { silent = true })
    end,
    after = function()
      local bufferline = require("bufferline")
      bufferline.setup({
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
  },
}
