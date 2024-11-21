{
  lib,
  pkgs,
  config,
  inputs,
  self,
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

        services.hyprpaper = {
          enable = true;
          settings = {
            preload = [ "${self}/assets/anime-nix-wallpaper.png" ];
            wallpaper = [ ", ${self}/assets/anime-nix-wallpaper.png" ];
          };
        };
        systemd.user.services.hyprpaper.Unit.After = lib.mkForce "graphical-session.target";
      }; # For Home-Manager options
  };
}
