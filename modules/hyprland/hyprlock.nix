{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.mine.hyprland;
in
{
  config = mkIf cfg.enable {
    hj.xdg.config.files."hypr/hyprlock.conf".text = ''
      $font = ${config.mine.fonts.terminal.name}

      general {
          hide_cursor = false
      }

      animations {
          enabled = true
          bezier = linear, 1, 1, 0, 0
          animation = fadeIn, 1, 5, linear
          animation = fadeOut, 1, 5, linear
          animation = inputFieldDots, 1, 2, linear
      }

      background {
          monitor =
          blur_passes = 2
      }

      input-field {
          monitor =
          size = 20%, 5%
          outline_thickness = 3

          # Transparent background
          inner_color = rgba(30, 30, 46, 0.0) # base00 with 0 alpha

          # Cyan -> Green
          outer_color = rgb(94e2d5) rgb(a6e3a1) 45deg

          # Green -> Orange
          check_color = rgb(a6e3a1) rgb(fab387) 120deg

          # Red -> Orange
          fail_color = rgb(f38ba8) rgb(fab387) 40deg

          font_color = rgb(cdd6f4) # base05
          fade_on_empty = false
          rounding = 5

          font_family = $font
          placeholder_text = Input Password...
          fail_text = $PAMFAIL

          dots_spacing = 0.3

          position = 0, -20
          halign = center
          valign = center
      }

      # TIME
      label {
          monitor =
          text = $TIME
          font_size = 90
          font_family = $font

          position = -30, 0
          halign = right
          valign = top
      }

      # DATE
      label {
          monitor =
          text = cmd[update:60000] date +"%A, %d %B %Y"
          font_size = 25
          font_family = $font

          position = -30, -150
          halign = right
          valign = top
      }
    '';
  };
}
