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

      # Sets environment variable `NIXOS_XDG_OPEN_USE_PORTAL` to `1`
      xdgOpenUsePortal = true;

      # uses the first portal implementation found in lexicographical order
      config.common.default = "*";
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
}
