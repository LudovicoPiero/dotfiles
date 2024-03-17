{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mine.games.lutris;
  inherit (lib) mkIf mkOption types;
in
{
  options.mine.games.lutris = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable lutris.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (lutris.override {
        extraPkgs = pkgs: [
          pkgs.wineWowPackages.staging
          pkgs.pixman
          pkgs.libjpeg
          pkgs.gnome.zenity
        ];
      })
    ];
  };
}
