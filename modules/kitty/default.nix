{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  _ = lib.getExe;

  cfg = config.myOptions.kitty;
in
{
  options.myOptions.kitty = {
    enable = mkEnableOption "kitty" // {
      default = config.vars.withGui;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.vars.username} =
      { config, osConfig, ... }:
      let
        inherit (config.colorScheme) palette;
      in
      {
        programs.kitty = {
          enable = true;

          shellIntegration.mode = "no-rc no-cursor";

          font = {
            name = "${osConfig.myOptions.fonts.terminal.name}";
            size = osConfig.myOptions.fonts.size;
            package = osConfig.myOptions.fonts.main.package;
          };

          keybindings = {
            "ctrl+a>c" = "new_tab_with_cwd";
            "ctrl+a>v" = "new_window_with_cwd";
            "ctrl+a>ctrl+c" = "new_tab";
            "ctrl+a>ctrl+v" = "new_window";
            "alt+k" = "scroll_line_up";
            "shift+up" = "scroll_line_up";
            "alt+j" = "scroll_line_down";
            "shift+down" = "scroll_line_down";
            "alt+t" = "new_tab";
            "ctrl+shift+f" =
              "launch --type=overlay --stdin-source=@screen_scrollback ${_ pkgs.dash} -c \"${_ pkgs.fzf} --no-sort --no-mouse --exact -i --tac | ${_ pkgs.kitty} +kitten clipboard\"";

            # Tabs
            "ctrl+a>1" = "goto_tab 1";
            "ctrl+a>2" = "goto_tab 2";
            "ctrl+a>3" = "goto_tab 3";
            "ctrl+a>4" = "goto_tab 4";
            "ctrl+a>5" = "goto_tab 5";
          };

          settings = {
            window_padding_width = 3;
            cursor_shape = "block";
            disable_ligatures = "cursor";
            scrollback_lines = 5000;
            enable_audio_bell = false;
            update_check_interval = 0;
            open_url_with = "xdg-open";
            confirm_os_window_close = 0;
            cursor_blink_interval = 0; # 0 = Disable cursor blinking
            background_blur = if osConfig.vars.opacity < 1 then 0.9 else 1;

            # Tab bar
            tab_bar_min_tabs = 1;
            tab_bar_edge = "bottom";
            tab_bar_style = "powerline";
            tab_powerline_style = "slanted";
            tab_title_template = "{index}:{title}";
          };

          # Color
          extraConfig = ''
            background #${palette.base00}
            foreground #${palette.base05}
            selection_background #${palette.base05}
            selection_foreground #${palette.base00}
            url_color #${palette.base04}
            cursor #${palette.base05}
            cursor_text_color #${palette.base00}
            active_border_color #${palette.base03}
            inactive_border_color #${palette.base01}
            active_tab_background #${palette.base00}
            active_tab_foreground #${palette.base05}
            inactive_tab_background #${palette.base01}
            inactive_tab_foreground #${palette.base04}
            tab_bar_background #${palette.base01}
            wayland_titlebar_color #${palette.base00}
            macos_titlebar_color #${palette.base00}

            # normal
            color0 #${palette.base00}
            color1 #${palette.base08}
            color2 #${palette.base0B}
            color3 #${palette.base0A}
            color4 #${palette.base0D}
            color5 #${palette.base0E}
            color6 #${palette.base0C}
            color7 #${palette.base05}

            # bright
            color8 #${palette.base03}
            color9 #${palette.base08}
            color10 #${palette.base0B}
            color11 #${palette.base0A}
            color12 #${palette.base0D}
            color13 #${palette.base0E}
            color14 #${palette.base0C}
            color15 #${palette.base07}

            # extended base16 colors
            color16 #${palette.base09}
            color17 #${palette.base0F}
            color18 #${palette.base01}
            color19 #${palette.base02}
            color20 #${palette.base04}
            color21 #${palette.base06}
          '';
        };
      }; # For Home-Manager options
  };
}
