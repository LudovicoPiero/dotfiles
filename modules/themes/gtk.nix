{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.mine.gtk;

  theme = {
    name = "Tokyonight-Dark";
    package = pkgs.tokyonight-gtk-theme;
  };

  iconTheme = {
    name = "Papirus-Dark";
    package = pkgs.papirus-icon-theme;
  };

  cursorTheme = {
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 24;
  };

  font = {
    inherit (config.mine.fonts.main) name;
    inherit (config.mine.fonts) size;
  };
in
{
  options.mine.gtk = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable GTK Theme configuration.";
    };
  };

  config = mkIf cfg.enable {
    hj = {
      packages = [
        theme.package
        iconTheme.package
        cursorTheme.package
      ];

      xdg.config.files = {
        "gtk-3.0/settings.ini".text = ''
          [Settings]
          gtk-theme-name=${theme.name}
          gtk-icon-theme-name=${iconTheme.name}
          gtk-font-name=${font.name} ${toString font.size}
          gtk-cursor-theme-name=${cursorTheme.name}
          gtk-cursor-theme-size=${toString cursorTheme.size}
          gtk-application-prefer-dark-theme=1
          gtk-xft-antialias=1
          gtk-xft-hinting=1
          gtk-xft-hintstyle=hintslight
          gtk-xft-rgba=rgb
        '';

        "gtk-4.0/settings.ini".text = ''
          [Settings]
          gtk-theme-name=${theme.name}
          gtk-icon-theme-name=${iconTheme.name}
          gtk-font-name=${font.name} ${toString font.size}
          gtk-cursor-theme-name=${cursorTheme.name}
          gtk-cursor-theme-size=${toString cursorTheme.size}
          gtk-application-prefer-dark-theme=1
        '';
      };

      files.".gtkrc-2.0".text = ''
        gtk-theme-name="${theme.name}"
        gtk-icon-theme-name="${iconTheme.name}"
        gtk-font-name="${font.name} ${toString font.size}"
        gtk-cursor-theme-name="${cursorTheme.name}"
        gtk-cursor-theme-size=${toString cursorTheme.size}
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
    };

    environment.sessionVariables = {
      GTK_THEME = theme.name;
      XCURSOR_THEME = cursorTheme.name;
      XCURSOR_SIZE = toString cursorTheme.size;
    };
  };
}
