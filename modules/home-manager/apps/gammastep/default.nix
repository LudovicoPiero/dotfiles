{
  config,
  lib,
  pkgs,
  ...
}: {
  services.gammastep = {
    enable = true;
    dawnTime = "6:00-7:45";
    duskTime = "18:35-20:15";
    latitude = "-27.4"; # Obviously not my real address :)
    longitude = "153.0";
    provider = "manual";
    settings = {
      general = {
        adjustment-method = "randr";
      };
      randr = {
        screen = 0;
      };
    };
    tray = true; # Enable tray
  };
}
