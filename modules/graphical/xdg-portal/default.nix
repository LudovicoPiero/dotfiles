{
  config,
  lib,
  pkgs,
  userName,
  ...
}:
let
  cfg = config.mine.xdg-portal;
  inherit (lib) mkIf mkOption types;
in
{
  options.mine.xdg-portal = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable xdg-portal.
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${userName} = {
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
  };
}
