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

  mkService =
    extra:
    {
      Unit = {
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
        Description = extra.Unit.Description;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    }
    // extra;

  cfg = config.myOptions.hyprland;
in
{
  imports = [
    inputs.hyprland.nixosModules.default
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprsunset.nix
  ];

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
                    ./patches/add-env-vars-to-export.patch
                    ./patches/enable-lto.patch
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
      { osConfig, ... }:
      {

        # User Services
        systemd.user.services =
          let
            wallpaperUrl = pkgs.fetchurl {
              url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/wallpapers/nix-wallpaper-waterfall.png";
              hash = "sha256-ULFNUZPU9khDG6rtkMskLe5sYpUcrJVvcFvEkpvXjMM=";
            };
          in
          {
            swaybg = mkService {
              Unit.Description = "Swaybg Services";
              Service = {
                ExecStart = "${lib.getExe pkgs.swaybg} --mode center --image ${wallpaperUrl}";
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
          xwayland.enable = false;

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
