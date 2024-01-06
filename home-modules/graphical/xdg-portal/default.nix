{
  config,
  lib,
  pkgs,
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
          (pkgs.xdg-desktop-portal-hyprland.overrideAttrs (
            _old: rec {
              version = "1.2.5";
              src = pkgs.fetchFromGitHub {
                owner = "hyprwm";
                repo = "xdg-desktop-portal-hyprland";
                rev = "v${version}";
                hash = "sha256-X4o/mifI7Nhu0UKYlxx53wIC+gYDo3pVM9L2u3PE2bE=";
              };

              patches = [
                (pkgs.fetchpatch {
                  url = "https://github.com/hyprwm/xdg-desktop-portal-hyprland/commit/576a49ef3d940d0391ba18b21e5f279ebd75e12b.patch";
                  hash = "sha256-szXHYM/U6NQqiECNSVAE+4sogDvI01JrcGuq6R1QKUU=";
                })
              ];
            }
          ))
        ];
      };
    };
  };
}
