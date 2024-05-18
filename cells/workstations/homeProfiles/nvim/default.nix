{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;
    withRuby = true;
    withPython3 = true;

    plugins = with pkgs.vimPlugins; [ nvim-treesitter.withAllGrammars ];

    extraPackages = with pkgs; [
      # Nix
      inputs.nixfmt.packages.${pkgs.system}.nixfmt
      nixd
      deadnix
      statix

      # Lua
      lua-language-server
      stylua

      # Python
      nodePackages.pyright
      isort
      black

      # C/C++
      gcc
      clang
      clang-tools # for headers stuff

      # Rust
      rust-analyzer

      # Etc
      ripgrep
      fd
      nodePackages.prettier
      shfmt
      gnumake
    ];
  };

  xdg.configFile = {
    "nvim/init.lua" = {
      source = ./init.lua;
    };
    "nvim/lua" = {
      source = ./__lua;
      recursive = true;
    };
  };
}
