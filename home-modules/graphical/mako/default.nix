{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mine.mako;
  inherit (lib) mkIf mkOption types;
  inherit (config.colorScheme) colors;
in {
  options.mine.mako = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable mako and set configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.libnotify];
    services.mako = {
      enable = true;

      anchor = "top-right";
      backgroundColor = "#${colors.base00}";
      borderColor = "#${colors.base0E}";
      textColor = "#${colors.base05}";
      borderRadius = 0;
      borderSize = 2;
      padding = "20";
      defaultTimeout = 5000;
      font = "Iosevka q 10";
      layer = "top";
      height = 100;
      width = 300;

      extraConfig = ''
        [urgency=low]
        border-color=#${colors.base0B}
        background-color=#${colors.base01}
        default-timeout=3000

        [urgency=high]
        background-color=#${colors.base01}
        border-color=#${colors.base0B}
        default-timeout=10000
      '';
    };
  };
}
