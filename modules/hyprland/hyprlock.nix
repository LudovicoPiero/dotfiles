{
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.myOptions.theme.colorScheme) palette;

  cfg = config.myOptions.hyprlock;
in
{
  options.myOptions.hyprlock = {
    enable = mkEnableOption "hyprlock service";
  };

  config = mkIf cfg.enable {
    security.pam.services.hyprlock.text = "auth include login";

    hj.rum.programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          grace = 30;
          no_fade_in = true;
          disable_loading_bar = true;
          hide_cursor = false;
        };

        background.path = "${inputs.self}/assets/Lain_Red.png";

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
  };
}
