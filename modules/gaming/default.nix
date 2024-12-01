{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    ;

  cfg = config.myOptions.gaming;
in {
  options.myOptions.gaming = {
    enable =
      mkEnableOption "gaming"
      // {
        default = config.myOptions.vars.withGui;
      };

    withGamemode = mkOption {
      type = types.bool;
      default = true;
    };

    withSteam = mkOption {
      type = types.bool;
      default = true;
    };
  };

  # config = mkIf cfg.enable {
  config = mkMerge [
    (mkIf cfg.withGamemode
      {
        programs.gamemode = let
          programs = lib.makeBinPath (
            with pkgs; [
              gojq
              systemd
            ]
          );

          startscript = pkgs.writeShellScript "gamemode-start" ''
            export PATH=$PATH:${programs}
            export HYPRLAND_INSTANCE_SIGNATURE=$(ls -w1 /tmp/hypr | tail -1)
            hyprctl --batch 'keyword decoration:blur:enabled 0 ; keyword animations:enabled 0'
            ${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Optimizations activated'
            ${lib.getExe' pkgs.mako "makoctl"} mode -a dnd
          '';

          endscript = pkgs.writeShellScript "gamemode-end" ''
            export PATH=$PATH:${programs}
            export HYPRLAND_INSTANCE_SIGNATURE=$(ls -w1 /tmp/hypr | tail -1)
            hyprctl --batch 'keyword decoration:blur:enabled 1 ; keyword animations:enabled 1'
            ${lib.getExe' pkgs.mako "makoctl"} mode -r dnd
            ${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Optimizations deactivated'
          '';
        in {
          enable = true;
          enableRenice = true;
          settings = {
            general = {
              softrealtime = "auto";
              renice = 15;
            };
            custom = {
              start = startscript.outPath;
              end = endscript.outPath;
            };
          };
        };
      })

    (mkIf cfg.withSteam
      {
        hardware.steam-hardware.enable = true;
        programs.steam = {
          enable = true;

          extraCompatPackages = with pkgs; [luxtorpeda proton-ge-custom];

          # Open ports for Steam Remote Play
          remotePlay.openFirewall = false;

          # Open ports for Source Dedicated Server
          dedicatedServer.openFirewall = false;
        };
      })
  ];
}
