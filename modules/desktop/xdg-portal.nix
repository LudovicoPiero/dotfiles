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
      ++ (optional (config.programs.niri.enable or false) pkgs.xdg-desktop-portal-gnome);

      # Portal Configuration
      config = {
        # 'common' applies to all desktops unless overridden
        common = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
        };

        niri = {
          "org.freedesktop.impl.portal.Access" = "gtk";
          "org.freedesktop.impl.portal.FileChooser" = "gtk";
          "org.freedesktop.impl.portal.Notification" = "gtk";
          "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
        };

        sway = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.ScreenCast" = "wlr";
          "org.freedesktop.impl.portal.Screenshot" = "wlr";
          # ignore inhibit bc gtk portal always returns as success,
          # despite sway/the wlr portal not having an implementation,
          # stopping firefox from using wayland idle-inhibit
          "org.freedesktop.impl.portal.Inhibit" = "none";
        };
      };
    };
  };
}
