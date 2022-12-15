{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    coc = {
      enable = true;
      settings = {
        # Disable coc suggestion
        definitions.languageserver.enable = false;
        suggest.autoTrigger = "none";

        # coc-discord-rpc
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
      lsp-format-nvim

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
      nil # another nix languageserver
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
      set guicursor=n-v-c-i:block
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
