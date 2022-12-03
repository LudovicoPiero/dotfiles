{
  lib,
  config,
  pkgs,
  ...
}: let
  catppuccin-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "catppuccin-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "nvim";
      rev = "72540852ca00d7842ea1123635aecb9353192f0b";
      sha256 = "0mb3qhg5aaxvkc8h95sbwg5nm89w719l9apymc5rpmis4r0mr5zg";
    };
  };
in {
  home.packages = with pkgs; [
    rnix-lsp
    nixfmt # Nix
    nixpkgs-fmt
    sumneko-lua-language-server
    stylua # Lua
  ];

  programs.neovim = {
    enable = true;
    withNodeJs = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      vim-nix
      plenary-nvim
      dashboard-nvim
      copilot-vim
      lualine-nvim
      nerdtree
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-vsnip
      vim-vsnip
      nvim-cmp
      nvim-lspconfig
      bufferline-nvim
      zk-nvim
      nvim-colorizer-lua
      impatient-nvim
      telescope-nvim
      indent-blankline-nvim
      nvim-treesitter
    ];
  };
  xdg.configFile."nvim".source = ./.;
  # home.file.".config/nvim/settings.lua".source = ./init.lua;
  # extraConfig = ''
  #   luafile ~/.config/nvim/settings.lua
  # '';
}
