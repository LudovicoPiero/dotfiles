{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe';

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
      let
        cfgwm = config.wayland.windowManager;
      in
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
                on-timeout = "${getExe' cfgwm.hyprland.package "hyprctl"} dispatch dpms off; ${getExe' cfgwm.sway.package "swaymsg"} output HDMI-A-1 dpms off";
                on-resume = "${getExe' cfgwm.hyprland.package "hyprctl"} dispatch dpms on; ${getExe' cfgwm.sway.package "swaymsg"} output HDMI-A-1 dpms on";
              }
            ];
          };
        };
      };
  };
}
