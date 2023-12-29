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
        # wlr disabled because i'm using xdg-desktop-portal-hyprland
        wlr.enable = lib.mkForce false;
        enable = true;

        # uses the first portal implementation found in lexicographical order
        config.common.default = "*";
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
            }
          ))
        ];
      };
    };
  };
}
