return {
  "nvim-tree/nvim-tree.lua",
  lazy = true,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>n", "<cmd>NvimTreeToggle<CR>", desc = "Toggle File Explorer" },
    { "<leader>m", "<cmd>NvimTreeFocus<CR>", desc = "Focus File Explorer" },
  },
  opts = {
    sort = {
      sorter = "case_sensitive",
    },
    view = {
      width = 30,
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = true,
    },
  },
}
