{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.myOptions.mako;
in
{
  options.myOptions.mako = {
    enable = mkEnableOption "mako service" // {
      default = config.myOptions.vars.withGui;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.myOptions.vars.username} =
      { config, ... }:
      let
        inherit (config.colorScheme) palette;
      in
      {
        home.packages = [ pkgs.libnotify ];
        services.mako = {
          enable = true;

          backgroundColor = "#${palette.base00}";
          borderColor = "#${palette.base0E}";
          textColor = "#${palette.base05}";

          anchor = "top-right";
          borderRadius = 5;
          borderSize = 2;
          padding = "20";
          defaultTimeout = 5000;
          layer = "top";
          height = 100;
          width = 300;
          format = "<b>%s</b>\\n%b";

          extraConfig = ''
            [urgency=low]
            border-color=#${palette.base0B}
            background-color=#${palette.base01}
            default-timeout=3000

            [urgency=high]
            background-color=#${palette.base01}
            border-color=#${palette.base0B}
            default-timeout=10000

            [mode=dnd]
            invisible=1
          '';
        };
      }; # For Home-Manager options
  };
}
