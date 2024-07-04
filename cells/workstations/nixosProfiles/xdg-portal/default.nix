{ pkgs, ... }:
{
  xdg = {
    portal = {
      enable = true;

      config = {
        common = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        };
        hyprland.default = [
          "gtk"
          "hyprland"
        ];
      };

      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-hyprland
      ];
    };
  };
}
