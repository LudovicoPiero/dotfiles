{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf optional;
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
      ]
      ++ (optional (config.programs.niri.enable or false
      ) pkgs.xdg-desktop-portal-wlr);

      # Portal Configuration
      config = {
        # 'common' applies to all desktops unless overridden
        common = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];

          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
          "org.freedesktop.impl.portal.ScreenShot" = [ "wlr" ];
        };

        niri = {
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
          "org.freedesktop.impl.portal.ScreenShot" = [ "wlr" ];
        };

        hyprland = {
          "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
          "org.freedesktop.impl.portal.ScreenShot" = [ "hyprland" ];
        };
      };
    };
  };
}
