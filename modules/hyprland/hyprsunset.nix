{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.myOptions.hyprsunset;
in
{
  options.myOptions.hyprsunset = {
    enable = mkEnableOption "hyprsunset service" // {
      default = config.myOptions.hyprland.enable;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.hello ];

    home-manager.users.${config.vars.username} = {
      services.hyprsunset = {
        enable = true;
        transitions = {
          sunrise = {
            calendar = "*-*-* 06:00:00";
            requests = [
              [
                "temperature"
                "6500"
              ]
              [ "gamma 100" ]
            ];
          };
          sunset = {
            calendar = "*-*-* 19:00:00";
            requests = [
              [
                "temperature"
                "3500"
              ]
            ];
          };
        };
      };
    }; # For Home-Manager options
  };
}
