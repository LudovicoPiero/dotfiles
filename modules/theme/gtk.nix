{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkOption types mkIf;
  cfg = config.mine.theme;

  # We'll create a generic gtk module that can be enabled
  # on a per-host basis.
  gtkThemeCfg = config.mine.theme.gtk;

  # Generate GTK settings.ini content
  gtkSettings = pkgs.writeText "settings.ini" ''
    [Settings]
    gtk-theme-name=${cfg.name}
    gtk-icon-theme-name=${cfg.iconTheme}
    gtk-font-name=${cfg.font}
    gtk-cursor-theme-name=${cfg.cursorTheme}
    gtk-cursor-theme-size=24
  '';

  # Generate .gtkrc-2.0 content for GTK2 applications
  gtk2Config = pkgs.writeText ".gtkrc-2.0" ''
    include "${
      pkgs.buildEnv {
        name = "gtk-theme-env";
        paths = [ cfg.package ];
      }
    }/share/themes/${cfg.name}/gtk-2.0/gtkrc"
    gtk-theme-name="${cfg.name}"
    gtk-icon-theme-name="${cfg.iconTheme}"
    gtk-font-name="${cfg.font}"
    gtk-cursor-theme-name="${cfg.cursorTheme}"
    gtk-cursor-theme-size=24
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

  config = mkIf gtkThemeCfg.enable {
    # This uses the alias `hj` for `hjem.users.<username>`
    # defined in `modules/shared/hjem/default.nix`
    hj.files = {
      ".config/gtk-3.0/settings.ini".source = gtkSettings;
      ".config/gtk-4.0/settings.ini".source = gtkSettings;
      ".gtkrc-2.0".source = gtk2Config;
    };

    # Make the theme packages available in the user's profile
    hj.packages = [
      cfg.package
      cfg.iconPackage
      cfg.cursorPackage
      cfg.fontPackage
    ];
  };
}
