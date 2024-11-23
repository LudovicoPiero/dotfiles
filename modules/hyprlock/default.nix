{
  lib,
  self,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.myOptions.hyprlock;
in {
  options.myOptions.hyprlock = {
    enable =
      mkEnableOption "hyprlock service"
      // {
        default = config.myOptions.vars.withGui;
      };
  };

  config = mkIf cfg.enable {
    security.pam.services.hyprlock.text = "auth include login";

    home-manager.users.${config.myOptions.vars.username} = {config, ...}: let
      inherit (config.colorScheme) palette;
    in {
      programs.hyprlock = {
        enable = true;
        package = inputs.hyprlock.packages.${pkgs.system}.default;
        settings = {
          general = {
            grace = 30;
            no_fade_in = true;
            disable_loading_bar = true;
            hide_cursor = false;
          };

          background.path = "${self}/assets/Minato-Aqua-Dark.png";

          input-field = [
            {
              size = "200, 50";
              position = "0, -80";
              monitor = "";
              dots_center = true;
              fade_on_empty = false;
              outer_color = "rgb(${palette.base03})";
              inner_color = "rgb(${palette.base00})";
              font_color = "rgb(${palette.base05})";
              fail_color = "rgb(${palette.base08})";
              check_color = "rgb(${palette.base0A})";
              outline_thickness = 5;
              placeholder_text = ''Password...'';
              shadow_passes = 2;
            }
          ];
        };
      };
    }; # For Home-Manager options
  };
}
