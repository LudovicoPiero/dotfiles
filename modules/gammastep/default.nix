{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkIf
    ;

  cfg = config.mine.gammastep;
in
{
  options.mine.gammastep = {
    enable = mkEnableOption "Gammastep service";

    package = mkPackageOption pkgs "gammastep" { };
  };

  config = mkIf cfg.enable {
    # Location services for gammastep
    services.geoclue2 = {
      enable = true;
      appConfig.gammastep = {
        isAllowed = true;
        isSystem = true;
      };
    };

    systemd.user.services = {
      gammastep = {
        enable = true;
        description = "Display colour temperature adjustment";
        after = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        bindsTo = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          ExecStart = "${lib.getExe cfg.package}";
        };
      };

      gammastep-indicator = {
        enable = true;
        description = "Display colour temperature adjustment";
        after = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        bindsTo = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          ExecStart = "${lib.getExe' cfg.package "gammastep-indicator"}";
        };
      };
    };

    hj.rum.programs.gammastep = {
      enable = true;
      settings = {
        general = {
          brightness-day = 0.8;
          brightness-night = 0.6;
          temp-day = 5700;
          temp-night = 3600;
          location-provider = "geoclue2";
        };
      };
    };
  };
}
