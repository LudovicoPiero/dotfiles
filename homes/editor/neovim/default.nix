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
          sources = {
            "nvim-cmp" = null;
            "luasnip" = "[Luasnip]";
            "path" = "[Path]";
            "buffer" = "[Buffer]";
            "crates" = "[Crates]";
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
          lightbulb.enable = false;
          lspSignature.enable = true;
          lspconfig.enable = true;
          lspkind.enable = true;
          lspsaga.enable = true;
          nvimCodeActionMenu.enable = true;
          trouble.enable = false;
        };

        maps = {
          normal = {
            ";" = {
              noremap = true;
              action = ":";
            };
            "s" = {
              desc = "Hop Word";
              noremap = true;
              silent = true;
              action = "<cmd>HopWord <CR>";
            };
            "S" = {
              desc = "Hop Line";
              noremap = true;
              silent = true;
              action = "<cmd>HopLine <CR>";
            };
            "<C-s>" = {
              desc = "Hop Pattern";
              noremap = true;
              silent = true;
              action = "<cmd>HopPattern <CR>";
            };
            "<Left>" = {
              desc = "Vertical Resize +1";
              noremap = true;
              silent = true;
              action = "<cmd>vertical resize +1<CR>";
            };
            "<Right>" = {
              desc = "Vertical Resize -1";
              noremap = true;
              silent = true;
              action = "<cmd>vertical resize -1<CR>";
            };
            "<Up>" = {
              desc = "Resize -1";
              noremap = true;
              silent = true;
              action = "<cmd>resize -1<CR>";
            };
            "<Down>" = {
              desc = "Resize +1";
              noremap = true;
              silent = true;
              action = "<cmd>resize +1<CR>";
            };
          };
        };

        notes = {
          # orgmode.enable = true;
          todo-comments.enable = true;
        };

        # Discord Presence
        presence.presence-nvim.enable = true;

        statusline.lualine = {
          enable = true;
          theme = "palenight";
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
          name = "tokyonight";
          style = "storm";
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
            useTreesitter = true;
          };
        };

        extraPlugins = with pkgs.vimPlugins; {
          luasnip = {
            package = luasnip;
            setup = ''require("luasnip.loaders.from_vscode").lazy_load()'';
          };
          friendly-snippets = {
            package = friendly-snippets;
            after = ["luasnip"];
          };
          cmp_luasnip = {
            package = cmp_luasnip;
          };
          cmp-buffer = {
            package = cmp-buffer;
          };
        };

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
