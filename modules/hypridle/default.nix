{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.myOptions.hypridle;
in
{
  options.myOptions.hypridle = {
    enable = mkEnableOption "hypridle service" // {
      default = config.vars.withGui;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.vars.username} = {
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
            lock_cmd = "hyprlock";
          };

          listener = [
            {
              timeout = 300;
              on-timeout = "hyprlock";
            }
            {
              timeout = 350;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };
      systemd.user.services.hypridle.Unit.After = lib.mkForce "graphical-session.target";
    }; # For Home-Manager options
  };
}
