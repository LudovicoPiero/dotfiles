return {
  "yazi.nvim",
  beforeAll = function()
    vim.g.loaded_netrwPlugin = 1
  end,

  after = function()
    require("yazi").setup({
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
    })
  end,

  keys = {
    {
      "<leader>tf",
      mode = { "n", "v" },
      "<cmd>Yazi<cr>",
      desc = "Open yazi at the current file",
    },
    {
      "<leader>tc",
      "<cmd>Yazi cwd<cr>",
      desc = "Open the file manager in nvim's working directory",
    },
    {
      "<leader>tt",
      "<cmd>Yazi toggle<cr>",
      desc = "Resume the last yazi session",
    },
  },
}
