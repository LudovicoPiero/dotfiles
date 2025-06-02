{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;

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

    hm = {
      services.gammastep = {
        enable = true;
        provider = "geoclue2";
        settings = {
          general = {
            brightness-day = 0.8;
            brightness-night = 0.6;
          };
        };
      };
    };
  };
}
