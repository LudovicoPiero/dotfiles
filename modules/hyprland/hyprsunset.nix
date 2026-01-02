{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkAfter;
  cfg = config.mine.hyprland;
in
{
  config = mkIf cfg.enable {
    hj.xdg.config.files."hypr/hyprland.conf".text = mkAfter ''
      exec-once = ${lib.getExe pkgs.hyprsunset}
    '';

    hj.xdg.config.files."hypr/hyprsunset.conf".text = ''
      max-gamma = 150

      profile {
          time = 7:30
          identity = true
      }

      profile {
          time = 20:00
          temperature = 5500
          gamma = 0.8
      }
    '';
  };
}
