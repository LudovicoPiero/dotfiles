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
          # FIXME: remove overrideAttrs if nixpkgs pr didn't fail
          (pkgs.xdg-desktop-portal-hyprland.overrideAttrs rec {
            version = "1.2.6";

            src = pkgs.fetchFromGitHub {
              owner = "hyprwm";
              repo = "xdg-desktop-portal-hyprland";
              rev = "v${version}";
              hash = "sha256-VRr5Xc4S/VPr/gU3fiOD3vSIL2+GJ+LUrmFTWTwnTz4=";
            };
          })
        ];
      };
    };
  };
}
