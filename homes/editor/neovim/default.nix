{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    # I use coc only for coc-discord-rpc
    coc = {
      enable = true;
      settings = {
        # Disable coc suggestion
        definitions.languageserver.enable = false;
        suggest.autoTrigger = "none";

        # :CocInstall coc-discord-rpc
        # coc-discord-rpc
        rpc = {
          checkIdle = false;
          detailsViewing = "In {workspace_folder}";
          detailsEditing = "{workspace_folder}";
          lowerDetailsEditing = "Working on {file_name}";
        };
      };
    };

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
