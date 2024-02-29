{ config, lib, ... }:
let
  cfg = config.mine.kitty;
  inherit (config) colorScheme;
  inherit (colorScheme) palette;
  inherit (lib) mkOption mkIf types;
in
{
  options.mine.kitty = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable kitty and set configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      shellIntegration.mode = "no-rc no-cursor";

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
        active_border_color = "#${palette.base07}";
        active_tab_background = "#${palette.base0E}";
        active_tab_foreground = "#11111B";
        background = "#${palette.base00}";
        cursor = "#${palette.base06}";
        cursor_text_color = "#${palette.base00}";
        foreground = "#${palette.base05}";
        inactive_border_color = "#${palette.base01}";
        inactive_tab_background = "#${palette.base01}";
        inactive_tab_foreground = "#${palette.base05}";
        selection_background = "#${palette.base06}";
        selection_foreground = "#${palette.base00}";
        tab_bar_background = "#${palette.base01}";
        url_color = "#${palette.base06}";

        mark1_foreground = "#${palette.base00}";
        mark1_background = "#${palette.base07}";
        mark2_foreground = "#${palette.base00}";
        mark2_background = "#${palette.base0E}";
        mark3_foreground = "#${palette.base00}";
        mark3_background = "#74C7EC";

        color0 = "#${palette.base03}";
        color1 = "#${palette.base08}";
        color2 = "#${palette.base0B}";
        color3 = "#${palette.base0A}";
        color4 = "#${palette.base0D}";
        color5 = "#F5C2E7";
        color6 = "#${palette.base0C}";
        color7 = "#${palette.base05}";
        color8 = "#${palette.base04}";
        color9 = "#${palette.base08}";
        color10 = "#${palette.base0B}";
        color11 = "#${palette.base0A}";
        color12 = "#${palette.base0D}";
        color13 = "#F5C2E7";
        color14 = "#BAC2DE";
        color15 = "#A6ADC8";
      };
    };
  };
}
