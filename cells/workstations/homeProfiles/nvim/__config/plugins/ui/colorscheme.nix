{
  programs.nixvim = {
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha"; # latte, frappe, macchiato, mocha
        background = {
          # :h background
          light = "latte";
          dark = "mocha";
        };
        transparent_background = true; # # disables setting the background color.
        show_end_of_buffer = false; # # shows the '~' characters after the end of buffers
        term_colors = false; # # sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
          enabled = false; # # dims the background color of inactive window
          shade = "dark";
          percentage = 0.15; # # percentage of the shade to apply to the inactive window
        };
        no_italic = false; # # Force no italic
        no_bold = false; # # Force no bold
        no_underline = false; # # Force no underline
        default_integrations = true;
        integrations = {
          cmp = true;
          gitsigns = true;
          nvimtree = true;
          treesitter = true;
          notify = false;
          mini = {
            enabled = true;
            indentscope_color = "";
          };
        };
      };
    };
  };
}
