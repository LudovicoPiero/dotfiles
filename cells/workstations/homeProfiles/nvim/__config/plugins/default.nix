{
  imports = [
    # Telescope
    ./telescope/telescope.nix

    # Syntax
    ./syntax/vim-nix.nix
    ./syntax/treesitter.nix
    ./syntax/rainbow-delimiter.nix

    # LSP
    ./lsp/lsp.nix
    ./lsp/none-ls.nix

    # Git
    ./git/neogit.nix
    ./git/gitsigns.nix

    # Completion
    ./completion/cmp.nix

    # Keybinding
    ./keybinding/flash.nix
    ./keybinding/which-key.nix

    # Misc
    ./misc/neocord.nix
    ./misc/wakatime.nix
    ./misc/comment.nix
    ./misc/neotree.nix
    ./misc/mini.nix

    # UI
    ./ui/lualine.nix
    ./ui/indent-blankline.nix
    ./ui/colorscheme.nix
    ./ui/bufferline.nix
    ./ui/nvim-colorizer.nix
    ./ui/nvim-notify.nix
    ./ui/todo.nix
    ./ui/noice.nix
  ];
}
