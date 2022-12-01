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
  #   home.file.".config/nvim/settings.lua".source = ./init.lua;

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
      catppuccin-nvim
      nvim-treesitter
    ];

    extraPackages = with pkgs; [gcc ripgrep fd];

    # https://github.com/fufexan/dotfiles/blob/main/home/editors/neovim/default.nix#L41
    extraConfig = let
      luaRequire = module:
        builtins.readFile (builtins.toString
          ./config
          + "/${module}.lua");
      luaConfig = builtins.concatStringsSep "\n" (map luaRequire [
        "init"
        "bufferline"
        "cmp"
        "colorizer"
        "dashboard"
        "impatient"
        "indent-blankline"
        "lualine"
        "telescope"
        "theme"
        "treesiter"
        "zk"
      ]);
    in ''
      lua <<
      ${luaConfig}
    '';

    # extraConfig = ''
    #   luafile ~/.config/nvim/settings.lua
    # '';
  };
}
