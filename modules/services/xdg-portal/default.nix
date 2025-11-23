{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.xdg-portal;
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
            # uses the first portal implementation found in lexicographical order
            default = [ "*" ];
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          };
        };

        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-hyprland
        ];
      };
    };
  };
}
