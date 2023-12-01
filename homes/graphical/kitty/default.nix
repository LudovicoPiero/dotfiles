{config, ...}: let
  inherit (config) colorScheme;
  inherit (colorScheme) colors;
in {
  programs.kitty = {
    enable = true;

    settings = {
      font_family = "Iosevka q SemiBold";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_size = 14;

      scrollback_lines = 5000;
      enable_audio_bell = false;
      update_check_interval = 0;
      window_padding_width = 10;
      open_url_with = "xdg-open";
      confirm_os_window_close = 0;

      # Tab bar
      tab_bar_min_tabs = 1;
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";

      # Colors
      active_border_color = "#${colors.base03}";
      active_tab_background = "#${colors.base00}";
      active_tab_foreground = "#${colors.base05}";
      background = "#${colors.base00}";
      cursor = "#${colors.base05}";
      foreground = "#${colors.base05}";
      inactive_border_color = "#${colors.base01}";
      inactive_tab_background = "#${colors.base01}";
      inactive_tab_foreground = "#${colors.base04}";
      selection_background = "#${colors.base05}";
      selection_foreground = "#${colors.base00}";
      tab_bar_background = "#${colors.base01}";
      url_color = "#${colors.base04}";

      color0 = "#${colors.base00}";
      color1 = "#${colors.base08}";
      color2 = "#${colors.base0B}";
      color3 = "#${colors.base0A}";
      color4 = "#${colors.base0D}";
      color5 = "#${colors.base0E}";
      color6 = "#${colors.base0C}";
      color7 = "#${colors.base05}";
      color8 = "#${colors.base03}";
      color9 = "#${colors.base09}";
      color10 = "#${colors.base01}";
      color11 = "#${colors.base02}";
      color12 = "#${colors.base04}";
      color13 = "#${colors.base06}";
      color14 = "#${colors.base0F}";
      color15 = "#${colors.base07}";
    };
  };
}
