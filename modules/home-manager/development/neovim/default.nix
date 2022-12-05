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
  programs.neovim = {
    enable = true;
    withNodeJs = false;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    coc = {
        enable = true;
        settings = {
            languageserver.enable = false; # I'm using cmp
            rpc = {
                checkIdle = false;
                detailsViewing = "In {workspace_folder}";
                detailsEditing = "{workspace_folder}";
                lowerDetailsEditing = "Working on {file_name}";
            };
            # ...
        };
    };

    plugins = with pkgs.vimPlugins; [
      # presence-nvim
      catppuccin-nvim
      vim-nix
      plenary-nvim
      dashboard-nvim
      copilot-vim
      lualine-nvim
      nvim-tree-lua
      bufferline-nvim
      nvim-colorizer-lua
      impatient-nvim
      telescope-nvim
      indent-blankline-nvim
      nvim-treesitter
      comment-nvim
      vim-fugitive
      nvim-web-devicons

      # Cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-vsnip
      vim-vsnip
      nvim-cmp
      nvim-lspconfig
    ];

    extraPackages = with pkgs; [
      nodejs-16_x # for copilot
      rnix-lsp
      nixfmt # Nix
      nixpkgs-fmt
      sumneko-lua-language-server
      stylua # Lua
      rust-analyzer
      gcc
      ripgrep
      fd
    ];

    # https://github.com/fufexan/dotfiles/blob/main/home/editors/neovim/default.nix#L41
    extraConfig = let
      luaRequire = module:
        builtins.readFile (builtins.toString
          ./lua
          + "/${module}.lua");
      luaConfig = builtins.concatStringsSep "\n" (map luaRequire [
        "cmp"
        "colorizer"
        "keybind"
        "settings"
        "theme"
        "ui"
      ]);
    in ''
      lua << EOF
      ${luaConfig}
      EOF
    '';
  };
  # home.file.".config/nvim/settings.lua".source = ./init.lua;
  # extraConfig = ''
  #   luafile ~/.config/nvim/settings.lua
  # '';
}
