return {
  {
    "yazi.nvim",
    dependencies = { "plenary.nvim" },
    keys = {
      { "<leader>tf", mode = { "n", "v" }, "<cmd>Yazi<cr>", desc = "Open yazi at the current file" },
      { "<leader>tc", "<cmd>Yazi cwd<cr>", desc = "Open the file manager in nvim's working directory" },
      { "<leader>tt", "<cmd>Yazi toggle<cr>", desc = "Resume the last yazi session" },
    },
    after = function()
      vim.g.loaded_netrwPlugin = 1
      require("yazi").setup({
        open_for_directories = false,
        keymaps = { show_help = "<f1>" },
      })
    end,
  },
}
