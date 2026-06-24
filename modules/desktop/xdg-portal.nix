{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.portal;
in
{
  options.mine.portal = {
    enable = mkEnableOption "XDG Desktop Portal configuration";
  };

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;

      extraPortals = [
        pkgs.xdg-desktop-portal-gtk # Fallback / File chooser
        pkgs.xdg-desktop-portal-wlr
      ];

      # Portal Configuration
      config = {
        # 'common' applies to all desktops unless overridden
        common = {
          default = [ "gtk" ];
        };

        mango = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
          "org.freedesktop.impl.portal.ScreenShot" = [ "wlr" ];

          # wlr does not have this interface, let gtk handle
          "org.freedesktop.impl.portal.Inhibit" = [ "gtk" ];
        };
      };
    };
  };
}
