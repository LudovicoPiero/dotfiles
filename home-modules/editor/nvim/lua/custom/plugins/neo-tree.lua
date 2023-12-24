return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  opts = {
    close_if_last_window = true,
    window = {
      width = 20,
    },
    filesystem = {
      filtered_items = {
        always_show = {
          ".gitignore",
          ".cargo",
          ".github",
        },
      },
    },
  },
  keys = {
    {
      "<C-n>",
      function()
        require("neo-tree.command").execute({ toggle = true })
      end,
      desc = "Neotree Toggle",
    },
    { "<C-m>", "<cmd>Neotree reveal<cr>", desc = "Neotree Focus" },
  },
}
