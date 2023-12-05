{config, ...}: let
  inherit (config) colorScheme;
  inherit (colorScheme) colors;
in {
  programs.kitty = {
    enable = true;

    keybindings = {
      "ctrl+shift+enter" = "new_window_with_cwd";
      "ctrl+shift+t" = "new_tab_with_cwd";
    };

    settings = {
      font_family = "Iosevka q SemiBold";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_size = 14;

      cursor_shape = "block";
      disable_ligatures = "cursor";
      scrollback_lines = 5000;
      enable_audio_bell = false;
      update_check_interval = 0;
      open_url_with = "xdg-open";
      confirm_os_window_close = 0;

      # Tab bar
      tab_bar_min_tabs = 1;
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";

      # Colors
      active_border_color = "#${colors.base07}";
      active_tab_background = "#${colors.base0E}";
      active_tab_foreground = "#11111B";
      background = "#${colors.base00}";
      cursor = "#${colors.base06}";
      cursor_text_color = "#${colors.base00}";
      foreground = "#${colors.base05}";
      inactive_border_color = "#${colors.base01}";
      inactive_tab_background = "#${colors.base01}";
      inactive_tab_foreground = "#${colors.base05}";
      selection_background = "#${colors.base06}";
      selection_foreground = "#${colors.base00}";
      tab_bar_background = "#${colors.base01}";
      url_color = "#${colors.base06}";

      mark1_foreground = "#${colors.base00}";
      mark1_background = "#${colors.base07}";
      mark2_foreground = "#${colors.base00}";
      mark2_background = "#${colors.base0E}";
      mark3_foreground = "#${colors.base00}";
      mark3_background = "#74C7EC";

      color0 = "#${colors.base03}";
      color1 = "#${colors.base08}";
      color2 = "#${colors.base0B}";
      color3 = "#${colors.base0A}";
      color4 = "#${colors.base0D}";
      color5 = "#F5C2E7";
      color6 = "#${colors.base0C}";
      color7 = "#${colors.base05}";
      color8 = "#${colors.base04}";
      color9 = "#${colors.base08}";
      color10 = "#${colors.base0B}";
      color11 = "#${colors.base0A}";
      color12 = "#${colors.base0D}";
      color13 = "#F5C2E7";
      color14 = "#BAC2DE";
      color15 = "#A6ADC8";
    };
  };
}
