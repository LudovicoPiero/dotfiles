{
  pkgs,
  lib,
  ...
}: {
  xdg = {
    portal = {
      # wlr disabled because i'm using xdg-desktop-portal-hyprland
      wlr.enable = lib.mkForce false;
      enable = true;

      # uses the first portal implementation found in lexicographical order
      config.common.default = "*";
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
}
