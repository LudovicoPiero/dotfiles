{
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.myOptions.gammastep;
in {
  options.myOptions.gammastep = {
    enable =
      mkEnableOption "gammastep service"
      // {
        default = config.myOptions.vars.withGui;
      };
  };

  config = mkIf cfg.enable {
    # Location for gammastep
    services.geoclue2 = {
      enable = true;
      appConfig.gammastep = {
        isAllowed = true;
        isSystem = false;
      };
    };

    home-manager.users.${config.myOptions.vars.username} = {
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
    }; # For Home-Manager options
  };
}
