{
  pkgs,
  config,
  ...
}: let
  inherit (config.colorscheme) colors;
in {
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "FiraCode Nerd Font";
      font_size = 11;
      font_features = "FiraCode Nerd Font +cv01 +cv02 +cv12 +ss05 +ss04 +ss03 +cv31 +cv29 +cv24 +cv25 +cv26 +ss07 +zero +onum";
      scrollback_lines = 100;
      window_border_width = "1px";
      confirm_os_window_close = 0;
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_bar_min_tabs = 1;
      tab_powerline_style = "slanted";
      tab_title_template = "{title} | {num_windows}";
      background_opacity = "0.88";
      enable_audio_bell = "no";

      # Layout
      enabled_layouts = "fat,stack";

      # Theme
      foreground = "#${colors.base05}";
      background = "#${colors.base00}";
      selection_background = "#${colors.base05}";
      selection_foreground = "#${colors.base00}";
      cursor = "#${colors.base05}";
      inactive_border_color = "#${colors.base01}";
      active_border_color = "#${colors.base03}";
      active_tab_background = "#${colors.base00}";
      active_tab_foreground = "#${colors.base05}";
      inactive_tab_background = "#${colors.base01}";
      inactive_tab_foreground = "#${colors.base04}";
      tab_bar_background = "#${colors.base01}";
      color0 = "#${colors.base00}";
      color1 = "#${colors.base08}";
      color2 = "#${colors.base0B}";
      color3 = "#${colors.base0A}";
      color4 = "#${colors.base0D}";
      color5 = "#${colors.base0E}";
      color6 = "#${colors.base0C}";
      color7 = "#${colors.base05}";
      color8 = "#${colors.base03}";
      color9 = "#${colors.base08}";
      color10 = "#${colors.base0B}";
      color11 = "#${colors.base0A}";
      color12 = "#${colors.base0D}";
      color13 = "#${colors.base0E}";
      color14 = "#${colors.base0C}";
      color15 = "#${colors.base07}";
      color16 = "#${colors.base09}";
      color17 = "#${colors.base0F}";
      color18 = "#${colors.base01}";
      color19 = "#${colors.base02}";
      color20 = "#${colors.base04}";
      color21 = "#${colors.base06}";
    };
  };
}
