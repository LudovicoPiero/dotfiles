{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.mine.i3;
in
{
  config = mkIf cfg.enable {
    services.picom = {
      enable = true;
      backend = "glx";
      vSync = false;
      settings = {
        corner-radius = 0;
        shadow = false;
        fading = false;
      };
    };
  };
}
