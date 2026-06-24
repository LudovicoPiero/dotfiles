{ config, lib, ... }:
{
  config = lib.mkIf config.mine.nvim.enable {
    programs.nvf.settings.vim = {
      tabline.nvimBufferline = {
        enable = true;

        setupOpts = {
          options = {
            mode = "buffers";
            themable = true;
            numbers = "none";

            indicator = {
              style = "none";
            };

            separator_style = "thin";

            show_buffer_close_icons = false;
            show_close_icon = false;
            color_icons = true;

            diagnostics = "nvim_lsp";
            diagnostics_update_in_insert = false;

            diagnostics_indicator = lib.generators.mkLuaInline ''
              function(count, level)
                local icon = level:match("error") and "󰅚 " or "󰀪 "
                return " " .. icon .. count
              end
            '';

            enforce_regular_tabs = false;
            always_show_bufferline = true;
            sort_by = "insert_after_current";
          };
        };
      };

      visuals = {
        nvim-web-devicons.enable = true;
        highlight-undo.enable = true;
        blink-indent.enable = true;
        nvim-cursorline.enable = true;
        fidget-nvim.enable = true;
      };

      ui = {
        borders.enable = true;
        noice.enable = true;
        colorizer.enable = true;
        modes-nvim.enable = false; # The theme looks terrible with catppuccin
        illuminate.enable = true;
        smartcolumn = {
          enable = true;
          setupOpts.custom_colorcolumn = {
            # this is a freeform module, it's `buftype = int;` for configuring column position
            nix = "110";
            ruby = "120";
            java = "130";
            go = [
              "90"
              "130"
            ];
          };
        };
      };

      keymaps = [
        {
          key = "<Tab>";
          mode = "n";
          action = "<cmd>BufferLineCycleNext<CR>";
          desc = "Next Buffer";
        }
        {
          key = "<S-Tab>";
          mode = "n";
          action = "<cmd>BufferLineCyclePrev<CR>";
          desc = "Prev Buffer";
        }
        {
          key = "<leader>bp";
          mode = "n";
          action = "<cmd>BufferLinePick<CR>";
          desc = "Pick Buffer";
        }
        {
          key = "<leader>bo";
          mode = "n";
          action = "<cmd>BufferLineCloseOthers<CR>";
          desc = "Close Other Buffers";
        }
      ];
    };
  };
}
