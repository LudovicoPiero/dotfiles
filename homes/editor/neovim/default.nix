{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.neovim-flake.homeManagerModules.default];

  programs.neovim-flake = {
    enable = true;
    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;
        package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
        enableEditorconfig = true;
        preventJunkFiles = true;
        enableLuaLoader = true;
        wordWrap = true;

        binds.whichKey.enable = true;

        autocomplete = {
          enable = true;
          mappings = {
            close = "<C-e>";
            complete = "<C-Space>";
            confirm = "<CR>";
            next = "<Tab>";
            previous = "<S-Tab>";
            scrollDocsDown = "<C-j>";
            scrollDocsUp = "<C-k>";
          };
        };

        comments.comment-nvim.enable = true;

        git = {
          enable = true;
          gitsigns.enable = true;
        };

        languages = {
          enableExtraDiagnostics = false;
          enableFormat = false;
          enableLSP = true;
          enableTreesitter = true;

          clang = {
            enable = true;
            lsp.server = "clangd";
            cHeader = true;
          };

          go.enable = true;
          html.enable = true;
          markdown.enable = true;

          nix = {
            enable = true;
            extraDiagnostics = {
              enable = true;
              types = ["statix" "deadnix"];
            };
          };

          python = {
            enable = true;
            format.enable = true;
          };

          rust = {
            enable = true;
            crates.enable = true;
          };

          ts = {
            enable = true;
            extraDiagnostics.enable = true;
            format.enable = true;
          };
        };

        mapLeaderSpace = true;
        lineNumberMode = "relative";

        lsp = {
          enable = true;
          formatOnSave = true;
          lightbulb.enable = true;
          lspSignature.enable = true;
          lspconfig.enable = true;
          lspkind.enable = true;
          lspsaga.enable = false;
          nvimCodeActionMenu.enable = true;
          trouble.enable = false;
        };

        maps = {
          normal.";" = {
            noremap = true;
            action = ":";
          };
        };

        notes = {
          # orgmode.enable = true; #FIXME: enable if fixed upstream
          todo-comments.enable = true;
        };

        # Discord Presence
        presence.presence-nvim.enable = true;

        statusline.lualine = {
          enable = true;
          theme = "dracula";
        };

        tabline.nvimBufferline = {
          enable = true;
          mappings = {
            closeCurrent = "<leader>xx";
          };
        };

        telescope = {
          enable = true;
          mappings = {
            buffers = "<leader>fb";
            diagnostics = "<leader>fd";
            findFiles = "<leader>ff";
            findProjects = "<leader>fp";
          };
        };

        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
          transparent = true;
        };

        # Enable color on text background
        ui.colorizer.enable = true;

        utility.motion.hop = {
          enable = true;
          mappings.hop = "<leader>h";
        };

        visuals = {
          nvimWebDevicons.enable = true;
          indentBlankline = {
            enable = true;
            # useTreesitter = true;
          };
        };

        #TODO: extraPlugins = {};

        treesitter = {
          enable = true;
          grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            lua
          ];
        };
      };
    };
  };
}
