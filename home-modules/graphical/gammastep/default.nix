{ config, lib, ... }:
let
  cfg = config.mine.gammastep;
  inherit (lib) mkIf mkOption types;
in
{
  options.mine.gammastep = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable gammastep and set configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.gammastep = {
      enable = true;
      provider = "geoclue2";
      tray = true;
      settings = {
        general = {
          brightness-day = "0.8";
          brightness-night = "0.8";
        };
      };
    };
  };
}
