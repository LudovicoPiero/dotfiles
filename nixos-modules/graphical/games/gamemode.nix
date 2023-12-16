{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.mine.games.gamemode;
  inherit (lib) mkIf mkOption types;
in {
  options.mine.games.gamemode = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable gamemode.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.gamemode = let
      programs = lib.makeBinPath (with pkgs; [
        inputs.hyprland.packages.${pkgs.system}.default
        gojq
        systemd
      ]);

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
  };
}
