{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config) colorScheme;
  inherit (colorScheme) palette;
  _ = lib.getExe;
in
{
  programs.kitty = {
    enable = true;

    shellIntegration.mode = "no-rc no-cursor";

    keybindings = {
      "ctrl+a>c" = "new_tab_with_cwd";
      "ctrl+a>v" = "new_window_with_cwd";
      "alt+k" = "scroll_line_up";
      "alt+j" = "scroll_line_down";
      "alt+t" = "new_tab";
      "ctrl+shift+k" = "scroll_page_up";
      "ctrl+shift+j" = "scroll_page_down";
      "ctrl+shift+f" = "launch --type=overlay --stdin-source=@screen_scrollback ${_ pkgs.dash} -c \"${_ pkgs.fzf} --no-sort --no-mouse --exact -i --tac | ${_ pkgs.kitty} +kitten clipboard\"";

      # Tabs
      "ctrl+a>1" = "goto_tab 1";
      "ctrl+a>2" = "goto_tab 2";
      "ctrl+a>3" = "goto_tab 3";
      "ctrl+a>4" = "goto_tab 4";
      "ctrl+a>5" = "goto_tab 5";
    };

    settings = {
      font_family = "Iosevka q SemiBold";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_size = 15;
      window_margin_width = 2;
      background_opacity = "1";

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
      tab_title_template = "{index}:{title}";

      # Colors
      active_border_color = "#${palette.base03}";
      active_tab_background = "#${palette.base00}";
      active_tab_foreground = "#${palette.base05}";
      background = "#${palette.base00}";
      foreground = "#${palette.base05}";
      cursor = "#${palette.base05}";
      # cursor_text_color = "#${palette.base00}";
      # inactive_border_color = "#${palette.base01}";
      inactive_tab_background = "#${palette.base01}";
      inactive_tab_foreground = "#${palette.base04}";
      selection_background = "#${palette.base05}";
      selection_foreground = "#${palette.base00}";
      tab_bar_background = "#${palette.base01}";
      url_color = "#${palette.base04}";

      mark1_foreground = "#${palette.base00}";
      mark1_background = "#${palette.base07}";
      mark2_foreground = "#${palette.base00}";
      mark2_background = "#${palette.base0E}";
      mark3_foreground = "#${palette.base00}";
      mark3_background = "#74C7EC";

      color0 = "#${palette.base00}";
      color1 = "#${palette.base08}";
      color2 = "#${palette.base0B}";
      color3 = "#${palette.base0A}";
      color4 = "#${palette.base0D}";
      color5 = "#${palette.base0E}";
      color6 = "#${palette.base0C}";
      color7 = "#${palette.base05}";
      color8 = "#${palette.base03}";
      color9 = "#${palette.base08}";
      color10 = "#${palette.base0B}";
      color11 = "#${palette.base0A}";
      color12 = "#${palette.base0D}";
      color13 = "#${palette.base0E}";
      color14 = "#${palette.base0C}";
      color15 = "#${palette.base07}";
      color16 = "#${palette.base09}";
      color17 = "#${palette.base0F}";
      color18 = "#${palette.base01}";
      color19 = "#${palette.base02}";
      color20 = "#${palette.base04}";
      color21 = "#${palette.base06}";
    };
  };
}
