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
          after_sleep_cmd = hyprctl dispatch dpms on
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
          on-timeout = hyprctl dispatch dpms off
          on-resume = hyprctl dispatch dpms on
      }

      listener {
          timeout = 900
          on-timeout = systemctl suspend
      }
    '';

    # Hyprlock Configuration
    hj.xdg.config.files."hypr/hyprlock.conf".text = ''
      general {
          disable_loading_bar = true
          grace = 5
          hide_cursor = true
          no_fade_in = false
      }

      background {
          monitor =
          path = screenshot
          color = rgba(${palette.base00}FF)
          blur_passes = 2
          blur_size = 4
          noise = 0.0117
          contrast = 0.8916
          brightness = 0.8172
          vibrancy = 0.1696
          vibrancy_darkness = 0.0
      }

      input-field {
          monitor =
          size = 250, 50
          outline_thickness = 2
          dots_size = 0.2
          dots_spacing = 0.2
          dots_center = true
          outer_color = rgba(${palette.base00}00)
          inner_color = rgba(${palette.base00}CC)
          font_color = rgb(${palette.base05})
          fade_on_empty = true
          placeholder_text = <i>Input Password...</i>
          hide_input = false
          position = 0, -120
          halign = center
          valign = center
      }

      label {
          monitor =
          text = cmd[update:1000] echo "$(date +'%H:%M')"
          color = rgba(${palette.base05}FF)
          font_size = 95
          font_family = ${font.terminal.name} Bold
          position = 0, 200
          halign = center
          valign = center
      }

      label {
          monitor =
          text = cmd[update:1000] echo "$(date +'%A, %d %B')"
          color = rgba(${palette.base05}FF)
          font_size = 22
          font_family = ${font.terminal.name}
          position = 0, 80
          halign = center
          valign = center
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
