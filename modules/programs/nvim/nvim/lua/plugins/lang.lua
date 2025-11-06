return {
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.rust" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.nix" },
  { import = "lazyvim.plugins.extras.lang.cpp" },
  { import = "lazyvim.plugins.extras.formatting.prettier" },
  { import = "lazyvim.plugins.extras.formatting.black" },
  { import = "lazyvim.plugins.extras.test.core" },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nixd = {},
        gopls = {},
        pyright = {},
        rust_analyzer = {},
        clangd = {},
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Prevent runtime downloading/compiling
      opts.ensure_installed = {}
      opts.auto_install = false
      opts.sync_install = false
    end,
  },

  -- Explicitly disable Mason for NixOS setup
  {
    "williamboman/mason.nvim",
    enabled = false,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    enabled = false,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    enabled = false,
  },
}
