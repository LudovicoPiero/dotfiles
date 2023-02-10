{
  config,
  lib,
  pkgs,
  ...
}: {
  xdg = {
    portal = {
      # wlr disabled because i'm using xdg-desktop-portal-hyprland
      wlr.enable = false;
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };
}
