{
  programs.nixvim = {
    plugins.noice = {
      enable = true;
      lsp.override = {
        "vim.lsp.util.convert_input_to_markdown_lines" = true;
        "vim.lsp.util.stylize_markdown" = true;
        "cmp.entry.get_documentation" = true;
      };
      views = {
        mini = {
          win_options.winblend = 0;
        };
        cmdline_popup = {
          position = {
            row = 13;
            col = "50%";
          };
          size = {
            min_width = 60;
            width = "auto";
            height = "auto";
          };
        };
        cmdline_popupmenu = {
          relative = "editor";
          position = {
            row = 16;
            col = "50%";
          };
          size = {
            width = 60;
            height = "auto";
            max_height = 15;
          };
          border = {
            style = "rounded";
            padding = [
              0
              1
            ];
          };
          win_options = {
            winhighlight = {
              Normal = "Normal";
              FloatBorder = "NoiceCmdlinePopupBorder";
            };
          };
        };
      };
      routes = [
        # Hide unnecessary messages
        {
          filter = {
            event = "msg_show";
            any = [
              { find = "%d+L, %d+B"; }
              { find = "; after #%d+"; }
              { find = "; before #%d+"; }
              { find = "%d fewer lines"; }
              { find = "%d more lines"; }
            ];
          };
          opts = {
            skip = true;
          };
        }
      ];
      presets = {
        bottom_search = true;
        command_palette = true;
        long_message_to_split = true;
        inc_rename = true;
      };
    };
  };
}
