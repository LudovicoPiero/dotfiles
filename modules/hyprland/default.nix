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
    mkMerge
    ;

  cfg = config.mine.hyprland;
in
{
  imports = [
    inputs.hyprland.nixosModules.default
    ./cliphist.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./settings.nix
  ];

  options.mine.hyprland = {
    enable = mkEnableOption "hyprland";

    package = mkOption {
      type = types.package;
      default = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      description = "The Hyprland package to use.";
    };

    withUWSM = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.withUWSM {
      programs.uwsm = {
        enable = true;
        waylandCompositors.hyprland = {
          binPath = "/run/current-system/sw/bin/Hyprland";
          prettyName = "Hyprland";
          comment = "Hyprland managed by UWSM";
        };
      };

      environment.sessionVariables = {
        APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";
        APP2UNIT_TYPE = "scope";
      };
    })

    {
      programs.hyprland = {
        enable = true;
        package = cfg.package;
        portalPackage =
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };

      hj.rum.programs.hyprland = {
        enable = true;

        extraConfig = ''
          # window resize
          bind = $mod, S, submap, resize

          submap = resize
          binde = , right, resizeactive, 10 0
          binde = , left, resizeactive, -10 0
          binde = , up, resizeactive, 0 -10
          binde = , down, resizeactive, 0 10
          bind = , escape, submap, reset
          submap = reset
        '';
      };
    }
  ]);
}
