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

    withUWSM = mkOption {
      type = types.bool;
      default = true;
      description = "Launch Hyprland apps with UWSM for better compatibility.";
    };
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      inherit (cfg) package withUWSM;
    };

    hj.packages = [ cfg.package ];
  };
}
