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
        indent-blankline.enable = true;
      };

      ui = {
        borders.enable = true;
        colorizer.enable = true;
        illuminate.enable = true;

        noice = {
          enable = true;
          setupOpts = {
            cmdline = {
              view = "cmdline";
              format = {
                search_down.view = "cmdline";
                search_up.view = "cmdline";
              };
            };
          };
        };
      };

      notify.nvim-notify = {
        enable = true;
        setupOpts.render = "compact";
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
