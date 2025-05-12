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
  imports = [
    inputs.hyprland.nixosModules.default
    ./cliphist.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./settings.nix
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
  };
}
