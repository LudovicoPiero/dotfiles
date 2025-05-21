{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  hyprlockPackage = config.hj.rum.programs.hyprlock.package;
  hypridlePackage = config.hj.rum.programs.hypridle.package;

  cfg = config.mine.hypridle;
in
{
  options.mine.hypridle = {
    enable = mkEnableOption "hypridle service";
  };

  config = mkIf cfg.enable {
    hj.rum.programs.hypridle = {
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
            on-timeout = "${config.programs.hyprland.package}/bin/hyprctl dispatch dpms off";
            on-resume = "${config.programs.hyprland.package}/bin/hyprctl dispatch dpms on";
          }
        ];
      };
    };

    systemd.user.services.hypridle = {
      enable = true;
      description = "Hyprland's idle daemon";
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      bindsTo = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = "${lib.getExe hypridlePackage}";
      };
    };
  };
}
