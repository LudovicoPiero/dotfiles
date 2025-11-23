{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;
  inherit (config.mine.theme.colorScheme) palette;

  cfg = config.mine.lockscreen;
  font = config.mine.fonts;

  # Binaries for interpolation
  hyprlockCmd = getExe pkgs.hyprlock;
  brightnessctl = getExe pkgs.brightnessctl;
  loginctl = "${pkgs.systemd}/bin/loginctl";
  hyprctl = "${config.mine.hyprland.package}/bin/hyprctl";
in
{
  options.mine.lockscreen = {
    enable = mkEnableOption "hyprlock and hypridle";
  };

  config = mkIf cfg.enable {
    # Hypridle Configuration
    hj.xdg.config.files."hypr/hypridle.conf".text = ''
      general {
          lock_cmd = pidof hyprlock || ${hyprlockCmd}
          before_sleep_cmd = ${loginctl} lock-session
          after_sleep_cmd = ${hyprctl} dispatch dpms on
      }

      listener {
          timeout = 150
          on-timeout = ${brightnessctl} -s set 10
          on-resume = ${brightnessctl} -r
      }

      listener {
          timeout = 300
          on-timeout = ${loginctl} lock-session
      }

      listener {
          timeout = 330
          on-timeout = ${hyprctl} dispatch dpms off
          on-resume = ${hyprctl} dispatch dpms on
      }

      listener {
          timeout = 1800 # 30min.
          on-timeout = systemctl suspend
      }
    '';

    # Hyprlock Configuration
    hj.xdg.config.files."hypr/hyprlock.conf".text = ''
      $font = ${font.terminal.name}
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
          #path = screenshot
          blur_passes = 2
      }

      input-field {
          monitor =
          size = 20%, 5%
          outline_thickness = 3

          # Transparent background (base00 with 00 alpha)
          inner_color = rgba(${palette.base00}00)

          # Cyan -> Green
          outer_color = rgba(${palette.base0C}ee) rgba(${palette.base0B}ee) 45deg

          # Green -> Orange
          check_color = rgba(${palette.base0B}ee) rgba(${palette.base09}ee) 120deg

          # Red -> Orange
          fail_color = rgba(${palette.base08}ee) rgba(${palette.base09}ee) 40deg

          font_color = rgb(${palette.base05})
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
          text = cmd[update:60000] date +"%A, %d %B %Y" # update every 60 seconds
          font_size = 25
          font_family = $font

          position = -30, -150
          halign = right
          valign = top
      }
    '';

    security.pam.services.hyprlock = { };
    security.pam.services.swaylock = { };
    # Enable the hypridle service
    systemd.user.services.hypridle = {
      description = "Hyprland idle daemon";

      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart = getExe pkgs.hypridle;
        Restart = "always";
        RestartSec = "1s";
      };
    };
  };
}
