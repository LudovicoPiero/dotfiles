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

  mkService = lib.recursiveUpdate {
    Unit.After = [ "multi-user.target" ];
    Install.WantedBy = [ "graphical.target" ];
  };

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
    programs = {
      uwsm = {
        enable = true;
        waylandCompositors.hyprland = {
          binPath = "/run/current-system/sw/bin/Hyprland";
          prettyName = "Hyprland";
          comment = "Hyprland managed by UWSM";
        };
      };

      hyprland = {
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
                    ./enable-lto.patch
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
    };

    home-manager.users.${config.vars.username} =
      { config, osConfig, ... }:
      {

        # User Services
        systemd.user.services = {
          swaybg = mkService {
            Unit.Description = "Swaybg Services";
            Service = {
              ExecStart = "${lib.getExe pkgs.swaybg} -m stretch -i ${config.xdg.userDirs.pictures}/Wallpaper/Lain_Red.png";
              Restart = "on-failure";
            };
          };
          wl-clip-persist = mkService {
            Unit.Description = "Keep Wayland clipboard even after programs close";
            Service = {
              ExecStart = "${lib.getExe pkgs.wl-clip-persist} --clipboard both";
              Restart = "on-failure";
              Slice = "app-graphical.slice";
              TimeoutStartSec = "10s";
            };
          };
        };

        imports = [ ./settings.nix ];
        wayland.windowManager.hyprland = {
          enable = true;
          package = osConfig.programs.hyprland.package;
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
      }; # For Home-Manager options
  };
}
