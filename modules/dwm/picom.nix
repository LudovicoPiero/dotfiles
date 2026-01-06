{ config, lib, ... }:

let
  cfg = config.mine.dwm;
in
{
  config = lib.mkIf cfg.enable {
    services.picom = {
      enable = true;
      backend = "glx";
      vSync = false;

      settings = {
        # Shadows
        shadow = false;
        shadow-radius = 0;
        shadow-offset-x = -7;
        shadow-offset-y = -7;

        # Fading
        fading = true;
        fade-in-step = 0.03;
        fade-out-step = 0.03;

        # Transparency / Opacity
        frame-opacity = 1.0;

        # Corners
        corner-radius = 0;

        # Blur
        blur-method = "dual_kawase";
        blur-strength = 5;
        blur-kern = "3x3box";

        # General Settings
        dithered-present = false;
        detect-rounded-corners = true;
        detect-client-opacity = true;
        detect-transient = true;
        use-damage = true;
      };
    };
  };
}
