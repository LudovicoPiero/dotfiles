{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkOption types mkIf;
  cfg = config.mine.theme;
  fontcfg = config.mine.fonts;

  # Generate GTK settings.ini content
  gtkSettings = pkgs.writeText "settings.ini" ''
    [Settings]
    gtk-theme-name=${cfg.gtk.theme.name}
    gtk-icon-theme-name=${cfg.gtk.iconTheme.name}
    gtk-font-name=${fontcfg.main.name} ${toString fontcfg.size}
    gtk-cursor-theme-name=${cfg.cursor.name}
    gtk-cursor-theme-size=${toString cfg.cursor.size}
  '';

  # Generate .gtkrc-2.0 content for GTK2 applications
  gtk2Config = pkgs.writeText ".gtkrc-2.0" ''
    include "${
      pkgs.buildEnv {
        name = "gtk-theme-env";
        paths = [ cfg.gtk.theme.package ];
      }
    }/share/themes/${cfg.gtk.theme.name}/gtk-2.0/gtkrc"
    gtk-theme-name="${cfg.gtk.theme.name}"
    gtk-icon-theme-name="${cfg.gtk.iconTheme.name}"
    gtk-font-name="${fontcfg.main.name} ${toString fontcfg.size}"
    gtk-cursor-theme-name="${cfg.cursor.name}"
    gtk-cursor-theme-size=${toString cfg.cursor.size}
  '';

in
{
  options.mine.theme.gtk = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable GTK theme configuration using hjem.";
    };
  };

  config = mkIf config.mine.theme.gtk.enable {
    # This uses the alias `hj` for `hjem.users.<username>`
    # defined in `modules/shared/hjem/default.nix`
    hj.files = {
      ".config/gtk-3.0/settings.ini".source = gtkSettings;
      ".config/gtk-4.0/settings.ini".source = gtkSettings;
      ".gtkrc-2.0".source = gtk2Config;
    };

    # Make the theme packages available in the user's profile
    hj.packages = [
      cfg.gtk.theme.package
      cfg.gtk.iconTheme.package
      cfg.cursor.package
    ];
  };
}
