return {
  "akinsho/bufferline.nvim",
  config = function()
    local bufferline = require("bufferline")

    bufferline.setup({
      highlights = {
        buffer_selected = { bold = true },
        diagnostic_selected = { bold = true },
        info_selected = { bold = true },
        info_diagnostic_selected = { bold = true },
        warning_selected = { bold = true },
        warning_diagnostic_selected = { bold = true },
        error_selected = { bold = true },
        error_diagnostic_selected = { bold = true },
      },
      options = {
        show_close_icon = false,
        diagnostics = "nvim_lsp",
        max_prefix_length = 8,
      },
    })

    vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>", { desc = "Cycle Buffer Next" })
    vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>", { desc = "Cycle Buffer Previous" })
  end,
}
