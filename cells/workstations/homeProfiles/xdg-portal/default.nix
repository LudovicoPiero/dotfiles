{ pkgs, inputs, ... }:
{
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
        inputs.xdph.packages.${pkgs.system}.default
      ];
    };
  };
}
