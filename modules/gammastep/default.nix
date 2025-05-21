{ lib, config, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.mine.gammastep;
in
{
  options.mine.gammastep = {
    enable = mkEnableOption "Gammastep service";
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
