{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.myOptions.hyprland;
in
{
  imports = [ inputs.hyprland.nixosModules.default ];

  options.myOptions.hyprland = {
    enable = mkEnableOption "hyprland";
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.default;
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };

    home-manager.users.${config.myOptions.vars.username} =
      { config, osConfig, ... }:
      {
        wayland.windowManager.hyprland = {
          enable = true;
          package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
          settings = import ./settings.nix {
            inherit
              pkgs
              lib
              config
              osConfig
              inputs
              ;
          };
          systemd.enable = !osConfig.programs.uwsm.enable;
        };
      }; # For Home-Manager options
  };
}
