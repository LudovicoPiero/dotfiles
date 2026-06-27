{ config, lib, ... }: {
  config = lib.mkIf config.mine.nvim.enable {
    programs.nvf.settings.vim = {
      autopairs.nvim-autopairs.enable = true;
      snippets.luasnip.enable = true;

      autocomplete.blink-cmp = {
        enable = true;
        friendly-snippets.enable = true;
        setupOpts.keymap = {
          preset = "enter";
        };
      };

      assistant.copilot = {
        enable = true;
        cmp.enable = true;
      };

      # Comment toggling (gcc / gc in visual)
      comments.comment-nvim.enable = true;

      # File tree sidebar
      utility = {
        oil-nvim = {
          enable = true;
          setupOpts = {
            view_options = {
              show_hidden = true;
            };
            default_file_explorer = true;
            column = [
              "permissions"
              "mtime"
              "size"
              "icon"
            ];
          };
        };

        motion.flash-nvim.enable = true;
      };

      # Better terminal integration
      terminal.toggleterm = {
        enable = true;
        setupOpts.open_mapping = "<C-\\>";
      };

      # Keymaps for editor plugins
      keymaps = [
        {
          key = "<leader>e";
          mode = "n";
          action = ":Oil<CR>";
          silent = true;
          desc = "Toggle Oil";
        }
      ];
    };
  };
}
