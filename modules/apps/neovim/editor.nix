{ config, lib, ... }:
{
  config = lib.mkIf config.mine.nvim.enable {
    programs.nvf.settings.vim = {
      # Auto-close brackets/quotes
      autopairs.nvim-autopairs.enable = true;

      # Comment toggling (gcc / gc in visual)
      comments.comment-nvim.enable = true;

      # File tree sidebar
      utility.oil-nvim = {
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
