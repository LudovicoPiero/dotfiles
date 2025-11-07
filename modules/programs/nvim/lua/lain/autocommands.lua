local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
    callback = function()
      vim.highlight.on_yank()
    end,
  })

  -- Auto-close help, quickfix, etc. with 'q'
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
    pattern = {
      "help",
      "qf",
      "lspinfo",
      "man",
      "checkhealth",
      "notify",
      "startuptime",
      "tsplayground",
      "PlenaryTestPopup",
    },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
      vim.keymap.set("n", "q", "<cmd>close<CR>", {
        buffer = event.buf,
        silent = true,
        desc = "Close window",
      })
    end,
  })
end

return M
