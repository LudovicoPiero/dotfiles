{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;
    withRuby = true;
    withPython3 = true;

    plugins = with pkgs.vimPlugins; [nvim-treesitter.withAllGrammars];

    extraPackages = with pkgs; [
      # Nix
      alejandra
      nil
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
