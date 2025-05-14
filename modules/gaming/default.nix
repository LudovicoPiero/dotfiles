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
    mkMerge
    mkOption
    types
    ;

  cfg = config.myOptions.gaming;
in
{
  options.myOptions.gaming = {
    enable = mkEnableOption "gaming";

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
    {
      environment.systemPackages = [
        inputs.minecraft.packages.${pkgs.stdenv.hostPlatform.system}.default
        inputs.anime.packages.${pkgs.stdenv.hostPlatform.system}.honkers-railway-launcher
      ];

      # Disable mihoyo telemetry
      networking.hosts = {
        "0.0.0.0" = [
          "overseauspider.yuanshen.com"
          "log-upload-os.hoyoverse.com"
          "log-upload-os.mihoyo.com"
          "dump.gamesafe.qq.com"

          "apm-log-upload-os.hoyoverse.com"
          "zzz-log-upload-os.hoyoverse.com"

          "log-upload.mihoyo.com"
          "devlog-upload.mihoyo.com"
          "uspider.yuanshen.com"
          "sg-public-data-api.hoyoverse.com"
          "hkrpg-log-upload-os.hoyoverse.com"
          "public-data-api.mihoyo.com"

          "prd-lender.cdp.internal.unity3d.com"
          "thind-prd-knob.data.ie.unity3d.com"
          "thind-gke-usc.prd.data.corp.unity3d.com"
          "cdp.cloud.unity3d.com"
          "remote-config-proxy-prd.uca.cloud.unity3d.com"

          "pc.crashsight.wetest.net"
        ];
      };
    }

    (mkIf cfg.withGamemode {
      programs.gamemode =
        let
          programs = lib.makeBinPath (
            with pkgs;
            [
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
        in
        {
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

    (mkIf cfg.withSteam {
      hardware.steam-hardware.enable = true;
      programs.steam = {
        enable = true;

        # Open ports for Steam Remote Play
        remotePlay.openFirewall = false;

        # Open ports for Source Dedicated Server
        dedicatedServer.openFirewall = false;
      };
    })
  ];
}
