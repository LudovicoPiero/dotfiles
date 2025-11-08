return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("fzf-lua").setup({
      {
        "max-perf",
        "ivy",
      },
      winopts = {
        preview = {
          default = "bat",
        },
      },
    })

    local fzf = require("fzf-lua")
    vim.keymap.set("n", "<leader>sq", fzf.quickfix, { desc = "[S]earch [Q]uickfix List" })
    vim.keymap.set("n", "<leader>sh", fzf.helptags, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>sk", fzf.keymaps, { desc = "[S]earch [K]eymaps" })
    vim.keymap.set("n", "<leader>sf", fzf.files, { desc = "[S]earch [F]iles" })
    vim.keymap.set("n", "<leader>sb", fzf.builtin, { desc = "[S]earch [B]uiltin FzfLua" })
    vim.keymap.set("n", "<leader>sw", fzf.grep_cword, { desc = "[S]earch current [W]ord" })
    vim.keymap.set("n", "<leader>sg", fzf.live_grep, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>sd", fzf.diagnostics_document, { desc = "[S]earch [d]iagnostic documents" })
    vim.keymap.set("n", "<leader>sD", fzf.diagnostics_workspace, { desc = "[S]earch [D]iagnostic workspace" })
    vim.keymap.set("n", "<leader>s.", fzf.oldfiles, { desc = "[S]earch Recent Files ('.' for repeat)" })
    vim.keymap.set("n", "<leader><leader>", fzf.buffers, { desc = "[ ] Find existing buffers" })
    vim.keymap.set("n", "<leader>/", fzf.lgrep_curbuf, { desc = "[S]earch [/] in Open Files" })
  end,
}
