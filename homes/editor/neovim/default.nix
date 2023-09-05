{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;
    withRuby = true;
    withPython3 = true;

    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
    ];

    extraPackages = with pkgs; [
      # Nix
      nil
      deadnix
      statix
      alejandra

      # Lua
      lua-language-server
      stylua

      # C/C++
      gcc
      clang
      clang-tools # for headers stuff

      # Etc
      rust-analyzer
      ripgrep
      fd
    ];
  };

  xdg.configFile."nvim" = {
    source = ./.;
    recursive = true;
  };
}
