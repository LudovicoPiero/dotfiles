{
  config,
  pkgs,
  ...
}: {
  home-manager.users.${config.vars.username} = {
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

          # :CocInstall coc-discord-rpc
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
        catppuccin-nvim
        vim-nix
        plenary-nvim
        dashboard-nvim
        lualine-nvim
        nvim-tree-lua
        bufferline-nvim
        nvim-colorizer-lua
        impatient-nvim
        telescope-nvim
        indent-blankline-nvim
        nvim-treesitter-context
        nvim-treesitter.withAllGrammars
        comment-nvim
        vim-fugitive
        nvim-web-devicons
        lsp-format-nvim
        which-key-nvim
        hop-nvim

        gitsigns-nvim
        # neogit

        #TODO: switch to coq
        # Cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        nvim-cmp
        nvim-lspconfig
        luasnip
        lspkind-nvim
        cmp_luasnip
      ];

      extraPackages = with pkgs; [
        alejandra
        lua-language-server
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
          "which-key"
        ]);
      in ''
        set guicursor=n-v-c-i:block
        lua << EOF
        ${luaConfig}
        EOF
      '';
    };
  };
}
