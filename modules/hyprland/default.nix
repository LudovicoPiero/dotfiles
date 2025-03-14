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
    ;

  cfg = config.myOptions.hyprland;
in
{
  imports = [ inputs.hyprland.nixosModules.default ];

  options.myOptions.hyprland = {
    enable = mkEnableOption "hyprland" // {
      default = config.myOptions.vars.withGui;
    };
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;

      package =
        (inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
          stdenv = pkgs.clangStdenv;
        }).overrideAttrs
          (prevAttrs: {
            patches = (prevAttrs.patches or [ ]) ++ [
              ./add-env-vars-to-export.patch
              ./enable-lto.patch
            ];
            mesonFlags = (prevAttrs.mesonFlags or [ ]) ++ [
              (lib.mesonBool "b_lto" true)
              (lib.mesonOption "b_lto_threads" "4")
              (lib.mesonOption "b_lto_mode" "thin")
              (lib.mesonBool "b_thinlto_cache" true)
            ];
          });
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };

    home-manager.users.${config.myOptions.vars.username} =
      {
        config,
        osConfig,
        ...
      }:
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
            preload = [
              "${self}/assets/Lain_Red.png"
              "${self}/assets/Minato-Aqua-Dark.png"
            ];
            wallpaper = [
              ", ${self}/assets/Minato-Aqua-Dark.png"
              "HDMI-A-1, ${self}/assets/Lain_Red.png"
            ];
          };
        };
        systemd.user.services.hyprpaper.Unit.After = lib.mkForce "graphical-session.target";
      }; # For Home-Manager options
  };
}
