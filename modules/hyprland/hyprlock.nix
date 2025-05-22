{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine.theme.colorScheme) palette;

  backgroundLink = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/49/wallhaven-497wow.jpg";
    hash = "sha256-OzpRjVb9gXnCGJW6mSai+E+TJUa5ycijxkOI2ch7PSQ=";
  };

  cfg = config.mine.hyprlock;
in
{
  options.mine.hyprlock = {
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
          font_family = config.mine.fonts.main.name;
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
