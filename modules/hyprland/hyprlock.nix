{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.myOptions.theme.colorScheme) palette;

  backgroundLink = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/0p/wallhaven-0pom5m.jpg";
    hash = "sha256-WHt/fDfCHlS4VZp+lydSHm8f7Pa0trf3WoiCCmG8Ih0=";
  };

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
          hide_cursor = false;
        };

        background = {
          path = "${backgroundLink}";
          color = "rgb(${palette.base03})"; # fallback color if path is not set
          blur_size = 0;
          blur_passes = 0;
        };

        input-field = {
          size = "400, 90";
          position = "0, -449";
          dots_center = true;
          fade_on_empty = false;
          font_family = config.myOptions.fonts.main.name;
          outer_color = "rgb(${palette.base03})";
          inner_color = "rgb(${palette.base00})";
          font_color = "rgb(${palette.base05})";
          fail_color = "rgb(${palette.base08})";
          check_color = "rgb(${palette.base0A})";
          capslock_color = "rgb(${palette.base0D})";
          outline_thickness = 5;
          placeholder_text = "Input Password...";
          shadow_passes = 2;
        };
      };
    };
  };
}
