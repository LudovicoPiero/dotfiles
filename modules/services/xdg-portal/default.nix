{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf optionals;

  cfg = config.mine.xdg-portal;
  minecfg = config.mine;

  portalConf =
    if minecfg.hyprland.enable then
      [ "hyprland" ]
    else if minecfg.mangowc.enable then
      [ "wlr" ]
    else
      [ ];
in
{
  options.mine.xdg-portal = {
    enable = mkEnableOption "xdg-portal service";
  };

  config = mkIf cfg.enable {
    xdg = {
      portal = {
        enable = true;

        config = {
          common = {
            default = [ "gtk" ];

            # except those
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
            "org.freedesktop.impl.portal.ScreenCast" = portalConf;
            "org.freedesktop.impl.portal.ScreenShot" = portalConf;

            # wlr does not have this interface
            "org.freedesktop.impl.portal.Inhibit" = [ ];
          };
          hyprland.default = [
            "gtk"
            "hyprland"
          ];
        };

        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
        ]
        ++ optionals minecfg.hyprland.enable [ pkgs.xdg-desktop-portal-hyprland ]
        ++ optionals minecfg.mangowc.enable [ pkgs.xdg-desktop-portal-wlr ];
      };
    };
  };
}
