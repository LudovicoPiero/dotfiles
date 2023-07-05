{
  config,
  pkgs,
  ...
}: {
  home-manager.users.${config.vars.username} = {
    programs.neovim = {
      enable = true;
      #TODO
      # package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
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
        # nvim-treesitter
        (nvim-treesitter.withPlugins (plugins:
          with plugins; [
            tree-sitter-bash
            tree-sitter-c
            tree-sitter-cpp
            tree-sitter-css
            tree-sitter-go
            tree-sitter-html
            tree-sitter-javascript
            tree-sitter-json
            tree-sitter-lua
            tree-sitter-nix
            tree-sitter-python
            tree-sitter-rust
            tree-sitter-scss
            tree-sitter-toml
            tree-sitter-tsx
            tree-sitter-typescript
            tree-sitter-yaml
          ]))
        comment-nvim
        vim-fugitive
        nvim-web-devicons
        lsp-format-nvim

        gitsigns-nvim

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
        # nodejs-16_x # for copilot
        alejandra
        lua-language-server
        stylua # Lua
        rust-analyzer
        gcc
        (ripgrep.override {withPCRE2 = true;})
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
  };
}
