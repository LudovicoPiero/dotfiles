{
  pkgs,
  inputs,
  ...
}: {
  programs.neovim = {
    enable = true;

    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;

    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      # Git Related
      vim-fugitive
      vim-rhubarb
      gitsigns-nvim

      # Detect tabstop and shiftwidth
      vim-sleuth

      # Lsp
      nvim-lspconfig
      mason-nvim
      mason-lspconfig-nvim
      fidget-nvim
      neodev-nvim

      # Autocomplete
      nvim-cmp
      luasnip
      cmp_luasnip
      cmp-nvim-lsp
      friendly-snippets

      # Theme
      catppuccin-nvim
      onedark-nvim
      lualine-nvim
      indent-blankline-nvim

      # Etc
      comment-nvim
      telescope-nvim
      plenary-nvim
      telescope-fzf-native-nvim
      nvim-treesitter.withAllGrammars
    ];

    extraPackages = with pkgs; [
      alejandra
      lua-language-server
      stylua # Lua
      rust-analyzer
      gcc
      clang-tools # for headers stuff
      ripgrep
      nil
      fd
    ];
  };

  xdg.configFile."nvim" = {
    source = ./config;
    recursive = true;
  };
}
