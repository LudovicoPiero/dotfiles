{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mine.thunar;
  inherit (lib) mkIf mkOption types;
in {
  options.mine.thunar = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable thunar ( File Manager ).
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.xfce.thunar];

    programs.thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];

    services = {
      gvfs.enable = true; # Mount, trash, and other functionalities
      tumbler.enable = true; # Thumbnail support for images
    };
  };
}
