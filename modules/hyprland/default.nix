{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.mine.hyprland;
in
{
  imports = [ ./_settings.nix ];
  options.mine.hyprland = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Hyprland.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.hyprland;
      description = "The Hyprland package to install.";
    };
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      inherit (cfg) package;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };

    hj.packages = [ cfg.package ];
  };
}
