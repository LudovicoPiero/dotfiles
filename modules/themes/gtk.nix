{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.mine.gtk;
in
{
  options.mine.gtk = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable GTK Theme configuration.";
    };

    theme = {
      name = mkOption {
        type = types.str;
        default = "WhiteSur-Dark";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.whitesur-gtk-theme;
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

    cursorTheme = {
      name = mkOption {
        type = types.str;
        default = "phinger-cursors-light";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.phinger-cursors;
      };
      size = mkOption {
        type = types.int;
        default = 24;
      };
    };

    font = {
      name = mkOption {
        type = types.str;
        default = config.mine.fonts.main.name;
      };
      size = mkOption {
        type = types.int;
        default = config.mine.fonts.size;
      };
    };
  };

  config = mkIf cfg.enable {
    hj = {
      packages = [
        cfg.theme.package
        cfg.iconTheme.package
        cfg.cursorTheme.package
      ];

      xdg.config.files = {
        "gtk-3.0/settings.ini".text = ''
          [Settings]
          gtk-theme-name=${cfg.theme.name}
          gtk-icon-theme-name=${cfg.iconTheme.name}
          gtk-font-name=${cfg.font.name} ${toString cfg.font.size}
          gtk-cursor-theme-name=${cfg.cursorTheme.name}
          gtk-cursor-theme-size=${toString cfg.cursorTheme.size}
          gtk-application-prefer-dark-theme=1
          gtk-xft-antialias=1
          gtk-xft-hinting=1
          gtk-xft-hintstyle=hintslight
          gtk-xft-rgba=rgb
        '';

        "gtk-4.0/settings.ini".text = ''
          [Settings]
          gtk-theme-name=${cfg.theme.name}
          gtk-icon-theme-name=${cfg.iconTheme.name}
          gtk-font-name=${cfg.font.name} ${toString cfg.font.size}
          gtk-cursor-theme-name=${cfg.cursorTheme.name}
          gtk-cursor-theme-size=${toString cfg.cursorTheme.size}
          gtk-application-prefer-dark-theme=1
        '';
      };

      files.".gtkrc-2.0".text = ''
        gtk-theme-name="${cfg.theme.name}"
        gtk-icon-theme-name="${cfg.iconTheme.name}"
        gtk-font-name="${cfg.font.name} ${toString cfg.font.size}"
        gtk-cursor-theme-name="${cfg.cursorTheme.name}"
        gtk-cursor-theme-size=${toString cfg.cursorTheme.size}
        gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
        gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
        gtk-button-images=1
        gtk-menu-images=1
        gtk-enable-event-sounds=1
        gtk-enable-input-feedback-sounds=1
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle=hintslight
        gtk-xft-rgba=rgb
      '';

      files.".local/share/icons/default/index.theme".text = ''
        [Icon Theme]
        Inherits=${cfg.cursorTheme.name}
      '';
    };

    environment.sessionVariables = {
      GTK_THEME = cfg.theme.name;
      XCURSOR_THEME = cfg.cursorTheme.name;
      XCURSOR_SIZE = toString cfg.cursorTheme.size;
    };
  };
}
