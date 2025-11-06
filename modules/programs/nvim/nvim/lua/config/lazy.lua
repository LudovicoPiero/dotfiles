-- NixOS-friendly LazyVim setup (no cloning, no Mason)
-- Assumes lazy.nvim is installed via Nix and already in &runtimepath

require("lazy").setup({
  spec = {
    -- Add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Import/override with your plugins
    { import = "plugins" },
  },

  defaults = {
    lazy = false,
    version = false, -- always use latest git commit
  },

  install = {
    colorscheme = { "gruvbox", "tokyonight", "habamax" },
  },

  checker = {
    enabled = false,
    notify = false,
  },

  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
