{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  hyprlockPackage = config.hm.programs.hyprlock.package;

  cfg = config.mine.hypridle;
in
{
  options.mine.hypridle = {
    enable = mkEnableOption "hypridle service";
  };

  config = mkIf cfg.enable {
    hm =
      { config, ... }:
      {
        services.hypridle = {
          enable = true;
          settings = {
            general = {
              before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
              lock_cmd = "${lib.getExe hyprlockPackage}";
            };

            listener = [
              {
                timeout = 300;
                on-timeout = "${lib.getExe hyprlockPackage}";
              }
              {
                timeout = 350;
                on-timeout = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms off";
                on-resume = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms on";
              }
            ];
          };
        };
      };
  };
}
