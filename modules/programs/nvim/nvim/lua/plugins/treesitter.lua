require("nvim-treesitter.configs").setup({
  ensure_installed = {},
  auto_install = false, -- Installed via nix
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "ruby" },
  },
  indent = { enable = true, disable = { "ruby" } },
})
