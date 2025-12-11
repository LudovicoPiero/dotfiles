return {
  -- Nvim Highlight Colors
  {
    "brenoprata10/nvim-highlight-colors",
    event = "VeryLazy",
    config = function()
      require("nvim-highlight-colors").setup({
        render = "virtual",
        virtual_symbol = "󱓻",
        virtual_symbol_suffix = " ",
        enable_hex = true,
        enable_var_usage = true,
        enable_named_colors = true,
        custom_colors = {
          { label = "%-%-theme%-primary%-color", color = "#0f1219" },
          { label = "%-%-theme%-secondary%-color", color = "#5a5d64" },
        },
      })
    end,
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          themable = true,
          numbers = "none",
          separator_style = "thin",
          show_buffer_close_icons = false,
          show_close_icon = false,
          color_icons = true,
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          diagnostics_indicator = function(count, level)
            local icon = level:match("error") and "󰅚 " or "󰀪 "
            return " " .. icon .. count
          end,
          offsets = {
            { filetype = "NvimTree", text = "Explorer", text_align = "left", separator = true },
            { filetype = "neo-tree", text = "Explorer", text_align = "left", separator = true },
          },
          sort_by = "insert_after_current",
        },
      })

      -- Keymaps
      local map = vim.keymap.set
      map("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
      map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
      map("n", "<leader>bp", "<cmd>BufferLinePick<cr>", { desc = "Pick Buffer" })
      map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close Other Buffers" })
    end,
  },
}
