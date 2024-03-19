{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mine.games.steam;
  inherit (lib) mkIf mkOption types;
in
{
  options.mine.games.steam = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable steam.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      package = pkgs.steam;
    };

    /*
      Enable udev rules for Steam hardware such as the Steam Controller,
      other supported controllers and the HTC Vive
    */
    hardware.steam-hardware.enable = true;
  };
}
