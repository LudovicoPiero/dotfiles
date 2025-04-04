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
    enable = mkEnableOption "hyprland" // {
      default = config.vars.withGui;
    };

    withLTO = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Link-Time Optimization (LTO)";
    };
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;

      package =
        let
          basePackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default;
          LTOPackage =
            (inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
              stdenv = pkgs.clangStdenv;
            }).overrideAttrs
              (prevAttrs: {
                patches = (prevAttrs.patches or [ ]) ++ [
                  ./add-env-vars-to-export.patch
                  ./enable-lto-thin.patch
                ];
                mesonFlags = (prevAttrs.mesonFlags or [ ]) ++ [
                  (lib.mesonBool "b_lto" true)
                  (lib.mesonOption "b_lto_threads" "4")
                  (lib.mesonOption "b_lto_mode" "thin")
                  (lib.mesonBool "b_thinlto_cache" true)
                ];
              });
        in
        if cfg.withLTO then LTOPackage else basePackage;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    home-manager.users.${config.vars.username} =
      { osConfig, ... }:
      {
        imports = [ ./settings.nix ];
        wayland.windowManager.hyprland = {
          enable = true;
          package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
          systemd.enable = !osConfig.programs.uwsm.enable;

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
