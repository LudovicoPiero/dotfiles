{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    getExe
    ;
  cfg = config.mine.hyprsunset;
in
{
  options.mine.hyprsunset = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable hyprsunset.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.hyprsunset;
      description = "The hyprsunset package to install.";
    };
  };

  config = mkIf cfg.enable {
    hj = {
      packages = [ cfg.package ];

      xdg.config.files."hypr/hyprsunset.conf".text = ''
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

    systemd.user.services.hyprsunset = {
      description = "Hyprsunset - automatic screen temperature adjustment for Hyprland";

      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart = getExe cfg.package;
        Restart = "always";
        RestartSec = "10s";
      };
    };
  };
}
