{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.myOptions.mako;
in
{
  options.myOptions.mako = {
    enable = mkEnableOption "mako service" // {
      default = config.myOptions.hyprland.enable;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.vars.username} =
      { config, osConfig, ... }:
      let
        inherit (config.colorScheme) palette;
      in
      {
        home.packages = [ pkgs.libnotify ];
        services.mako = {
          enable = true;

          font = "${osConfig.myOptions.fonts.terminal.name} ${toString osConfig.myOptions.fonts.size}";
          backgroundColor = "#${palette.base00}";
          borderColor = "#${palette.base0E}";
          textColor = "#${palette.base05}";
          progressColor = "over #${palette.base02}";

          anchor = "top-right";
          borderRadius = "5";
          borderSize = "2";
          padding = "20";
          defaultTimeout = "5000";
          layer = "top";
          height = "100";
          width = "300";
          format = "<b>%s</b>\\n%b";
        };
      }; # For Home-Manager options
  };
}
