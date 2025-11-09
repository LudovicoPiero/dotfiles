return {
  {
    "nvim-treesitter",
    lazy = false,
    after = function()
      require("nvim-treesitter.configs").setup({
        modules = {},
        sync_install = false,
        auto_install = false,
        ignore_install = {},
        ensure_installed = {},
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true, disable = { "ruby" } },
      })
    end,
  },
}
