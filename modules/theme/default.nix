{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.myOptions.theme;
in
{
  options.myOptions.theme = {
    enable = mkEnableOption "" // {
      default = config.vars.withGui;
    };

    colorScheme = mkOption {
      type = types.anything;
      default = inputs.nix-colors.colorSchemes.${config.vars.colorScheme};
    };

    gtk = {
      cursorTheme = {
        name = mkOption {
          type = types.str;
          default = "phinger-cursors-light";
        };
        size = mkOption {
          type = types.int;
          default = 24;
        };
        package = mkOption {
          type = types.package;
          default = pkgs.phinger-cursors;
        };
      };

      theme = {
        name = mkOption {
          type = types.str;
          default = "WhiteSur-Dark";
        };
        package = mkOption {
          type = types.package;
          default = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.whitesur-gtk-theme;
        };
      };

      iconTheme = {
        name = mkOption {
          type = types.str;
          default = "WhiteSur-dark";
        };
        package = mkOption {
          type = types.package;
          default = pkgs.whitesur-icon-theme;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme = "gtk2";
    };

    hj = {
      rum.gtk = {
        enable = true;
        packages = [
          cfg.gtk.theme.package
          cfg.gtk.iconTheme.package
          cfg.gtk.cursorTheme.package
        ];

        settings = {
          application-prefer-dark-theme = true;
          enable-animations = true;
          theme-name = cfg.gtk.theme.name;
          font-name = config.myOptions.fonts.main.name;
          cursor-theme = cfg.gtk.cursorTheme.name;
          cursor-size = cfg.gtk.cursorTheme.size;
          cursor-theme-name = cfg.gtk.cursorTheme.name;
          cursor-theme-size = cfg.gtk.cursorTheme.size;
          toolbar-style = "GTK_TOOLBAR_BOTH";
          toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
          button-images = 1;
          menu-images = 1;
          enable-event-sounds = 1;
          enable-input-feedback-sounds = 1;
          xft-antialias = 1;
          xft-hinting = 1;
          xft-hintstyle = "hintfull";
          xft-rgba = "rgb";
        };

        css = {
          gtk3 = ''
            @define-color borders_breeze #5f6265;
            @define-color content_view_bg_breeze #1b1e20;
            @define-color error_color_backdrop_breeze #da4453;
            @define-color error_color_breeze #da4453;
            @define-color error_color_insensitive_backdrop_breeze #592930;
            @define-color error_color_insensitive_breeze #592930;
            @define-color insensitive_base_color_breeze #1a1d1f;
            @define-color insensitive_base_fg_color_breeze #656768;
            @define-color insensitive_bg_color_breeze #282c30;
            @define-color insensitive_borders_breeze #3a3d41;
            @define-color insensitive_fg_color_breeze #6e7173;
            @define-color insensitive_selected_bg_color_breeze #282c30;
            @define-color insensitive_selected_fg_color_breeze #6e7173;
            @define-color insensitive_unfocused_bg_color_breeze #282c30;
            @define-color insensitive_unfocused_fg_color_breeze #6e7173;
            @define-color insensitive_unfocused_selected_bg_color_breeze #282c30;
            @define-color insensitive_unfocused_selected_fg_color_breeze #6e7173;
            @define-color link_color_breeze #1d99f3;
            @define-color link_visited_color_breeze #9b59b6;
            @define-color success_color_backdrop_breeze #27ae60;
            @define-color success_color_breeze #27ae60;
            @define-color success_color_insensitive_backdrop_breeze #1e4d34;
            @define-color success_color_insensitive_breeze #1e4d34;
            @define-color theme_base_color_breeze #1b1e20;
            @define-color theme_bg_color_breeze #2a2e32;
            @define-color theme_button_background_backdrop_breeze #31363b;
            @define-color theme_button_background_backdrop_insensitive_breeze #2f3338;
            @define-color theme_button_background_insensitive_breeze #2f3338;
            @define-color theme_button_background_normal_breeze #31363b;
            @define-color theme_button_decoration_focus_backdrop_breeze #3daee9;
            @define-color theme_button_decoration_focus_backdrop_insensitive_breeze #335c72;
            @define-color theme_button_decoration_focus_breeze #3daee9;
            @define-color theme_button_decoration_focus_insensitive_breeze #335c72;
            @define-color theme_button_decoration_hover_backdrop_breeze #3daee9;
            @define-color theme_button_decoration_hover_backdrop_insensitive_breeze #335c72;
            @define-color theme_button_decoration_hover_breeze #3daee9;
            @define-color theme_button_decoration_hover_insensitive_breeze #335c72;
            @define-color theme_button_foreground_active_backdrop_breeze #fcfcfc;
            @define-color theme_button_foreground_active_backdrop_insensitive_breeze #6e7173;
            @define-color theme_button_foreground_active_breeze #fcfcfc;
            @define-color theme_button_foreground_active_insensitive_breeze #6e7173;
            @define-color theme_button_foreground_backdrop_breeze #fcfcfc;
            @define-color theme_button_foreground_backdrop_insensitive_breeze #727679;
            @define-color theme_button_foreground_insensitive_breeze #727679;
            @define-color theme_button_foreground_normal_breeze #fcfcfc;
            @define-color theme_fg_color_breeze #fcfcfc;
            @define-color theme_header_background_backdrop_breeze #2a2e32;
            @define-color theme_header_background_breeze #31363b;
            @define-color theme_header_background_light_breeze #2a2e32;
            @define-color theme_header_foreground_backdrop_breeze #fcfcfc;
            @define-color theme_header_foreground_breeze #fcfcfc;
            @define-color theme_header_foreground_insensitive_backdrop_breeze #fcfcfc;
            @define-color theme_header_foreground_insensitive_breeze #fcfcfc;
            @define-color theme_hovering_selected_bg_color_breeze #3daee9;
            @define-color theme_selected_bg_color_breeze #3daee9;
            @define-color theme_selected_fg_color_breeze #fcfcfc;
            @define-color theme_text_color_breeze #fcfcfc;
            @define-color theme_titlebar_background_backdrop_breeze #2a2e32;
            @define-color theme_titlebar_background_breeze #31363b;
            @define-color theme_titlebar_background_light_breeze #2a2e32;
            @define-color theme_titlebar_foreground_backdrop_breeze #fcfcfc;
            @define-color theme_titlebar_foreground_breeze #fcfcfc;
            @define-color theme_titlebar_foreground_insensitive_backdrop_breeze #fcfcfc;
            @define-color theme_titlebar_foreground_insensitive_breeze #fcfcfc;
            @define-color theme_unfocused_base_color_breeze #1b1e20;
            @define-color theme_unfocused_bg_color_breeze #2a2e32;
            @define-color theme_unfocused_fg_color_breeze #fcfcfc;
            @define-color theme_unfocused_selected_bg_color_alt_breeze #1f485e;
            @define-color theme_unfocused_selected_bg_color_breeze #1f485e;
            @define-color theme_unfocused_selected_fg_color_breeze #fcfcfc;
            @define-color theme_unfocused_text_color_breeze #fcfcfc;
            @define-color theme_unfocused_view_bg_color_breeze #1a1d1f;
            @define-color theme_unfocused_view_text_color_breeze #656768;
            @define-color theme_view_active_decoration_color_breeze #3daee9;
            @define-color theme_view_hover_decoration_color_breeze #3daee9;
            @define-color tooltip_background_breeze #31363b;
            @define-color tooltip_border_breeze #64686b;
            @define-color tooltip_text_breeze #fcfcfc;
            @define-color unfocused_borders_breeze #5f6265;
            @define-color unfocused_insensitive_borders_breeze #3a3d41;
            @define-color warning_color_backdrop_breeze #f67400;
            @define-color warning_color_breeze #f67400;
            @define-color warning_color_insensitive_backdrop_breeze #633914;
            @define-color warning_color_insensitive_breeze #633914;
          '';
        };

        # bookmarks = [
        #   "file:///home/${config.vars.username}/Code"
        #   "file:///home/${config.vars.username}/Media"
        #   "file:///home/${config.vars.username}/Documents"
        #   "file:///home/${config.vars.username}/Downloads"
        #   "file:///home/${config.vars.username}/Games"
        #   "file:///home/${config.vars.username}/Music"
        #   "file:///home/${config.vars.username}/Pictures"
        #   "file:///home/${config.vars.username}/Videos"
        #   "file:///home/${config.vars.username}/WinE"
        # ];
      };

      files = {
        "gtk-4.0/assets".source = ./assets;
        "gtk-4.0/windows-assets".source = ./windows-assets;

        #HACK: I just manually run the install.sh and then copy paste it here.
        #TODO: Find a better way to do it.
        "gtk-4.0/gtk.css".source = ./gtk.css;
        "gtk-4.0/gtk-dark.css".source = ./gtk.css;
      };
    };
  };
}
